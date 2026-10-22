#!/usr/bin/env bash
# Scores a PR from the paths it changes. Reads one path per line on stdin, prints T0..T3.
# Fails safe: no paths, a missing/empty rules file, or any error resolves to T3.
#   RISK_MAP  path to the rules file (default .github/risk-map.txt)
set -uo pipefail

map="${RISK_MAP:-.github/risk-map.txt}"
rank() { echo "${1#T}"; }

rules=()
if [[ -r "$map" ]]; then
  while read -r tier glob; do
    [[ -z "${tier:-}" || "$tier" == \#* ]] && continue
    [[ "$tier" =~ ^T[0-3]$ && -n "${glob:-}" ]] || { echo T3; exit 0; }
    rules+=("$tier $glob")
  done <"$map"
fi
[[ ${#rules[@]} -gt 0 ]] || { echo T3; exit 0; }

max=-1
while IFS= read -r path; do
  [[ -z "$path" ]] && continue
  tier=T2
  for r in "${rules[@]}"; do
    # shellcheck disable=SC2053
    if [[ "$path" == ${r#* } ]]; then tier="${r%% *}"; break; fi
  done
  n=$(rank "$tier"); (( n > max )) && max=$n
done

(( max >= 0 )) && echo "T$max" || echo T3
