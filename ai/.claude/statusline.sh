#!/bin/bash
# Claude Code status line: modelo · dir · tokens en contexto / tamaño (porcentaje)
# Recibe el JSON de sesión por stdin (ver `statusLine` en ~/.claude/settings.json)
input=$(cat)

model=$(jq -r '.model.display_name // "?"' <<<"$input")
dir=$(jq -r '.workspace.current_dir // .cwd // ""' <<<"$input")
size=$(jq -r '.context_window.context_window_size // 0' <<<"$input")
# Tokens del último turno = lo que ocupa el contexto ahora mismo
used=$(jq -r '.context_window.current_usage
  | if . == null then 0
    else (.input_tokens // 0) + (.cache_creation_input_tokens // 0) + (.cache_read_input_tokens // 0) end' <<<"$input")
pct=$(jq -r '.context_window.used_percentage // empty' <<<"$input")
if [[ -z "$pct" && "$size" -gt 0 ]]; then
  pct=$(( used * 100 / size ))
fi

human() {
  local n=$1
  if (( n >= 1000000 )); then printf '%d.%dM' $((n / 1000000)) $((n % 1000000 / 100000))
  elif (( n >= 1000 )); then printf '%dk' $((n / 1000))
  else printf '%d' "$n"; fi
}

# Verde <50%, amarillo <80%, rojo a partir de ahí
pct_int=${pct%.*}
if (( ${pct_int:-0} >= 80 )); then color='\033[31m'
elif (( ${pct_int:-0} >= 50 )); then color='\033[33m'
else color='\033[32m'; fi

printf '%s · %s · %b%s / %s (%s%%)\033[0m' \
  "$model" "${dir/#$HOME/\~}" "$color" "$(human "$used")" "$(human "$size")" "${pct_int:-0}"
