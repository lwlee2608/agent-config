
## Disk Space

This machine (pomelo) has a small primary disk.

1. **Large files**: Keep clones, builds, downloads, venvs, and model weights inside the working directory when it is on `/Volumes/Dev`.
2. **No good place**: If the working directory is not on `/Volumes/Dev`, ask the user where to put large files.
3. **No new top-level dirs**: Never create new directories directly under `/Volumes/Dev`.
4. **Small `/tmp` only**: `/tmp` is on the primary disk. Keep files there small.
