#!/bin/bash
input=$(cat)

model=$(echo "$input" | jq -r '.model.display_name')
effort=$(echo "$input" | jq -r '.effort.level // empty')
used=$(echo "$input" | jq -r '.context_window.used_percentage // empty')
current_tokens=$(echo "$input" | jq -r '.context_window.total_input_tokens // empty')
max_tokens=$(echo "$input" | jq -r '.context_window.context_window_size // empty')
five_hour_pct=$(echo "$input" | jq -r '.rate_limits.five_hour.used_percentage // empty')
five_hour_reset=$(echo "$input" | jq -r '.rate_limits.five_hour.resets_at // empty')

fmt_k() {
  awk -v n="$1" 'BEGIN { printf "%dk", int(n / 1000 + 0.5) }'
}

line="$model"
[ -n "$effort" ] && line="$line [$effort]"

if [ -n "$used" ]; then
  used_int=$(printf '%.0f' "$used")
  width=21
  filled=$(( used_int * width / 100 ))
  [ "$filled" -gt "$width" ] && filled=$width
  empty=$(( width - filled ))

  bar=""
  for ((i = 0; i < filled; i++)); do bar+="█"; done
  for ((i = 0; i < empty; i++)); do bar+="░"; done

  line="$line  [$bar] ${used_int}%"

  window="${CLAUDE_CODE_AUTO_COMPACT_WINDOW:-$max_tokens}"
  if [ -n "$current_tokens" ] && [ -n "$window" ]; then
    cur_k=$(fmt_k "$current_tokens")
    win_k=$(fmt_k "$window")
    line="$line  ${cur_k} / ${win_k} tokens"
  fi
fi

# if [ -n "$five_hour_pct" ]; then
#   five_int=$(printf '%.0f' "$five_hour_pct")
#   rate_str="5h: ${five_int}%"
#   if [ -n "$five_hour_reset" ]; then
#     reset_time=$(date -d "@$five_hour_reset" +"%-I:%M%p" 2>/dev/null | tr 'AP' 'ap')
#     [ -n "$reset_time" ] && rate_str="$rate_str (resets $reset_time)"
#   fi
#   line="$line  •  $rate_str"
# fi

printf "\033[2m%s\033[0m" "$line"
