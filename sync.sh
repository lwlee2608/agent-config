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
  ["opencode/AGENTS.md"]="$HOME/.opencode/AGENTS.md"
  ["opencode/opencode.json"]="$HOME/.opencode/opencode.json"
)

updated=0
skipped=0

for src_rel in "${!FILE_MAP[@]}"; do
  src="$REPO_DIR/$src_rel"
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

  if diff -q "$src" "$dst" > /dev/null 2>&1; then
    echo -e "${BOLD}${CYAN}=== $src_rel ===${RESET}"
    echo -e "  ${GREEN}Up to date.${RESET}"
    echo ""
  else
    echo -e "${BOLD}${CYAN}=== $src_rel ===${RESET}"
    diff --color=always -u "$dst" "$src" | head -80 || true
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
