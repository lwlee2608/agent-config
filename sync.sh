#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="$(cd "$(dirname "$0")" && pwd)"

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
CYAN='\033[0;36m'
BOLD='\033[1m'
RESET='\033[0m'

declare -A FILE_MAP=(
  ["claudecode/CLAUDE.md"]="$HOME/.claude/CLAUDE.md"
  ["claudecode/settings.json"]="$HOME/.claude/settings.json"
  ["claudecode/statusline-command.sh"]="$HOME/.claude/statusline-command.sh"
  ["claudecode/output-styles/simple.md"]="$HOME/.claude/output-styles/simple.md"
  ["opencode/AGENTS.md"]="$HOME/.config/opencode/AGENTS.md"
  ["opencode/opencode.json"]="$HOME/.config/opencode/opencode.json"
  ["codex/AGENTS.md"]="$HOME/.codex/AGENTS.md"
  ["codex/config.toml"]="$HOME/.codex/config.toml"
)

# Codex appends per-machine tables to config.toml; keep those, replace the rest.
LOCAL_TOML_TABLES='^\[(projects\.|notice\.|tui\.)'

updated=0
skipped=0

normalize() {
  if [[ "$1" == *.json ]]; then
    jq -S . "$1"
  else
    cat "$1"
  fi
}

files_differ() {
  ! diff -q <(normalize "$1") <(normalize "$2") > /dev/null 2>&1
}

local_toml_tables() {
  awk -v re="$LOCAL_TOML_TABLES" '/^\[/ { keep = ($0 ~ re) } keep' "$1"
}

merged_source() {
  local src="$1" dst="$2"
  if [[ "$src" == *.toml && -f "$dst" ]]; then
    local tmp
    tmp="$(mktemp)"
    { cat "$src"; echo; local_toml_tables "$dst"; } > "$tmp"
    echo "$tmp"
  else
    echo "$src"
  fi
}

for src_rel in "${!FILE_MAP[@]}"; do
  src="$(merged_source "$REPO_DIR/$src_rel" "${FILE_MAP[$src_rel]}")"
  dst="${FILE_MAP[$src_rel]}"

  if [[ ! -f "$dst" ]]; then
    echo -e "${BOLD}${CYAN}=== $src_rel ===${RESET}"
    echo -e "  ${YELLOW}Target missing:${RESET} $dst"
    echo ""
    echo -e "${YELLOW}${BOLD}Create this file? [y/N]${RESET} \c"
    read -r answer
    if [[ "$answer" == "y" || "$answer" == "Y" ]]; then
      mkdir -p "$(dirname "$dst")"
      cp "$src" "$dst"
      echo -e "  ${GREEN}Created:${RESET} $dst"
      updated=$((updated + 1))
    else
      echo -e "  ${RED}Skipped.${RESET}"
      skipped=$((skipped + 1))
    fi
    echo ""
    continue
  fi

  if ! files_differ "$src" "$dst"; then
    echo -e "${BOLD}${CYAN}=== $src_rel ===${RESET}"
    echo -e "  ${GREEN}Up to date.${RESET}"
    echo ""
  else
    echo -e "${BOLD}${CYAN}=== $src_rel ===${RESET}"
    diff --color=always -u --label "$dst" --label "$src_rel" <(normalize "$dst") <(normalize "$src") | head -80 || true
    echo ""
    echo -e "${YELLOW}${BOLD}Update this file? [y/N]${RESET} \c"
    read -r answer
    if [[ "$answer" == "y" || "$answer" == "Y" ]]; then
      cp "$src" "$dst"
      echo -e "  ${GREEN}Updated:${RESET} $dst"
      updated=$((updated + 1))
    else
      echo -e "  ${RED}Skipped.${RESET}"
      skipped=$((skipped + 1))
    fi
    echo ""
  fi
done

if [[ $updated -eq 0 && $skipped -eq 0 ]]; then
  echo -e "${GREEN}All files are in sync.${RESET}"
else
  echo -e "${GREEN}${BOLD}Done.${RESET} ${updated} updated, ${skipped} skipped."
fi
