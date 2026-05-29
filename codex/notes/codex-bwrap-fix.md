# Codex CLI sandbox fix (bwrap userns under AppArmor)

## Symptom
Codex review/commands all failed with:
```
bwrap: loopback: Failed RTM_NEWADDR: Operation not permitted
```
Codex's bubblewrap sandbox couldn't create its network namespace, so every
filesystem/shell command inside it died.

## Root cause
Not a container. Kernel allowed userns (`unprivileged_userns_clone=1`), but
Ubuntu's AppArmor hardening blocked it for unconfined binaries:
```
kernel.apparmor_restrict_unprivileged_userns = 1
```
With no AppArmor profile granting `userns`, bwrap was denied namespace creation.

## Fix
Added a narrow AppArmor profile granting `userns` to bwrap **only**, leaving the
restriction in force for every other binary. Codex uses its own vendored bwrap
in `$HOME`, so the profile covers both that and the system one.

`/etc/apparmor.d/codex-bwrap`:
```
abi <abi/4.0>,
include <tunables/global>

profile codex-bwrap-system /usr/bin/bwrap flags=(unconfined) {
  userns,
  include if exists <local/codex-bwrap>
}

profile codex-bwrap-vendored /home/**/codex-resources/bwrap flags=(unconfined) {
  userns,
  include if exists <local/codex-bwrap>
}
```

Install + load (writes the profile above to its path, then loads it):
```bash
sudo tee /etc/apparmor.d/codex-bwrap > /dev/null <<'EOF'
abi <abi/4.0>,
include <tunables/global>

profile codex-bwrap-system /usr/bin/bwrap flags=(unconfined) {
  userns,
  include if exists <local/codex-bwrap>
}

profile codex-bwrap-vendored /home/**/codex-resources/bwrap flags=(unconfined) {
  userns,
  include if exists <local/codex-bwrap>
}
EOF
sudo apparmor_parser -r /etc/apparmor.d/codex-bwrap
```

## Verify
```bash
BWRAP=/usr/bin/bwrap   # or the vendored codex-resources/bwrap path
"$BWRAP" --unshare-net --ro-bind / / true   # exits 0 = OK
```

## Notes
- Persists across reboots. After a Node/Codex upgrade just re-run the
  `apparmor_parser -r` reload; the `/home/**/codex-resources/bwrap` glob already
  covers new version paths.
- `kernel.apparmor_restrict_unprivileged_userns` stays `1` — system hardening
  is preserved; only bwrap is exempted.
- Trade-off: the vendored bwrap lives at a user-writable path, so the profile is
  slightly weaker than one pinned to a root-owned binary — but far narrower than
  globally disabling the restriction.
