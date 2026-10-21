#!/usr/bin/env bash
# Aggregate gate. Reads the `needs` context as JSON on stdin and decides pass/fail.
#   REQUIRED  space-separated jobs that must be "success"
#   OPTIONAL  space-separated jobs that may be "success" or "skipped"
# Every job in `needs` must be listed in one of the two, so a new job cannot be forgotten.
# A failed or cancelled job always fails the gate.
set -euo pipefail

needs=$(cat)
rc=0

for job in $(jq -r 'keys[]' <<<"$needs"); do
  result=$(jq -r --arg j "$job" '.[$j].result' <<<"$needs")
  if [[ " ${REQUIRED:-} " == *" $job "* ]]; then
    [[ "$result" == "success" ]] || { echo "FAIL  $job: $result (required)"; rc=1; continue; }
  elif [[ " ${OPTIONAL:-} " == *" $job "* ]]; then
    [[ "$result" == "success" || "$result" == "skipped" ]] || { echo "FAIL  $job: $result (optional jobs may only be success or skipped)"; rc=1; continue; }
  else
    echo "FAIL  $job: not listed in REQUIRED or OPTIONAL"; rc=1; continue
  fi
  echo "ok    $job: $result"
done

# A required job that is missing from `needs` must fail too.
for job in ${REQUIRED:-}; do
  jq -e --arg j "$job" 'has($j)' <<<"$needs" >/dev/null || { echo "FAIL  $job: required but not in needs"; rc=1; }
done

[[ $rc -eq 0 ]] && echo "ci-gate: PASS" || echo "ci-gate: FAIL"
exit $rc
