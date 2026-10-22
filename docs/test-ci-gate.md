#!/usr/bin/env bash
# Tests for ci-gate.sh. Each case: name, expected exit code, REQUIRED, OPTIONAL, needs JSON.
cd "$(dirname "$0")"
fail=0
t() {
  local name=$1 want=$2 req=$3 opt=$4 json=$5
  REQUIRED="$req" OPTIONAL="$opt" ./ci-gate.sh <<<"$json" >/dev/null 2>&1
  local got=$?
  if [[ $got -eq $want ]]; then echo "pass  $name"; else echo "FAIL  $name (want $want, got $got)"; fail=1; fi
}
t "all required succeed"            0 "a b" ""  '{"a":{"result":"success"},"b":{"result":"success"}}'
t "required failure fails"          1 "a b" ""  '{"a":{"result":"success"},"b":{"result":"failure"}}'
t "required cancelled fails"        1 "a b" ""  '{"a":{"result":"success"},"b":{"result":"cancelled"}}'
t "required skipped fails"          1 "a b" ""  '{"a":{"result":"success"},"b":{"result":"skipped"}}'
t "optional skipped passes"         0 "a"   "o" '{"a":{"result":"success"},"o":{"result":"skipped"}}'
t "optional failure fails"          1 "a"   "o" '{"a":{"result":"success"},"o":{"result":"failure"}}'
t "optional cancelled fails"        1 "a"   "o" '{"a":{"result":"success"},"o":{"result":"cancelled"}}'
t "unlisted job fails"              1 "a"   ""  '{"a":{"result":"success"},"x":{"result":"success"}}'
t "required job missing from needs" 1 "a b" ""  '{"a":{"result":"success"}}'
# Canary: the harness itself must be able to report a failure.
REQUIRED="a" ./ci-gate.sh <<<'{"a":{"result":"failure"}}' >/dev/null 2>&1 && { echo "FAIL  canary: gate passed a failing job"; fail=1; } || echo "pass  canary"
exit $fail
