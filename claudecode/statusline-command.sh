#!/bin/bash
input=$(cat)

model=$(echo "$input" | jq -r '.model.display_name')
effort=$(echo "$input" | jq -r '.effort.level // empty')
used=$(echo "$input" | jq -r '.context_window.used_percentage // empty')
current_tokens=$(echo "$input" | jq -r '.context_window.total_input_tokens // empty')
max_tokens=$(echo "$input" | jq -r '.context_window.context_window_size // empty')
five_hour_pct=$(echo "$input" | jq -r '.rate_limits.five_hour.used_percentage // empty')
five_hour_reset=$(echo "$input" | jq -r '.rate_limits.five_hour.resets_at // empty')
total_cost=$(echo "$input" | jq -r '.cost.total_cost_usd // empty')
transcript=$(echo "$input" | jq -r '.transcript_path // empty')

if [ -f "$transcript" ]; then
  read -r cached uncached < <(jq -nr '
    reduce (inputs | select(.message.usage) | {k: (.requestId // .uuid), u: .message.usage}) as $e ({}; .[$e.k] = $e.u)
    | [.[]]
    | [(map(.cache_read_input_tokens // 0) | add),
       (map((.input_tokens // 0) + (.cache_creation_input_tokens // 0)) | add)]
    | @tsv' "$transcript" 2>/dev/null)
fi

fmt_k() {
  awk -v n="$1" 'BEGIN { printf "%dk", int(n / 1000 + 0.5) }'
}

fmt_t() {
  awk -v n="$1" 'BEGIN { if (n < 1000) printf "%d", n; else printf "%.1fk", n / 1000 }'
}

line="$model"
[ -n "$effort" ] && line="$line [$effort]"

window="${CLAUDE_CODE_AUTO_COMPACT_WINDOW:-$max_tokens}"

if [ -n "$current_tokens" ] && [ -n "$window" ] && [ "$window" -gt 0 ] 2>/dev/null; then
  used_int=$(awk -v c="$current_tokens" -v w="$window" 'BEGIN { printf "%d", (c * 100 / w) + 0.5 }')
elif [ -n "$used" ]; then
  used_int=$(printf '%.0f' "$used")
fi

if [ -n "$used_int" ]; then
  width=18
  filled=$(( used_int * width / 100 ))
  [ "$filled" -gt "$width" ] && filled=$width
  empty=$(( width - filled ))

  esc=$'\033'
  bar="${esc}[0m${esc}[38;5;252m"
  for ((i = 0; i < filled; i++)); do bar+="━"; done
  bar+="${esc}[38;5;238m"
  for ((i = 0; i < empty; i++)); do bar+="━"; done
  bar+="${esc}[0m${esc}[2m"

  line="$line  [$bar] ${used_int}%"

  if [ -n "$current_tokens" ] && [ -n "$window" ]; then
    cur_k=$(fmt_k "$current_tokens")
    win_k=$(fmt_k "$window")
    line="$line  ${cur_k} / ${win_k} tokens"
  fi
fi

if [ -n "$total_cost" ]; then
  cost_str=$(awk -v c="$total_cost" 'BEGIN { printf "$%.2f", c }')
  if [ -n "$cached" ] && [ $((cached + uncached)) -gt 0 ]; then
    hit=$(awk -v r="$cached" -v u="$uncached" 'BEGIN { printf "%d", (r * 100 / (r + u)) + 0.5 }')
    cost_str="$cost_str (${hit}% cached, $(fmt_t "$uncached") new)"
  fi
  line="$line  •  $cost_str"
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
