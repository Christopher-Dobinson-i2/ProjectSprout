#!/usr/bin/env bash
# Tests for risk-score.sh.
cd "$(dirname "$0")/.." || exit 1
fail=0
t() { # name want paths...
  local name=$1 want=$2; shift 2
  got=$(printf '%s\n' "$@" | ./scripts/risk-score.sh)
  if [[ "$got" == "$want" ]]; then echo "pass  $name"; else echo "FAIL  $name (want $want, got $got)"; fail=1; fi
}
t "docs only is T0"                    T0 docs/mac-demo.md README.md
t "xaml is T1"                         T1 src/Sprout.App/MainPage.xaml
t "xaml + docs is T1"                  T1 src/Sprout.App/MainPage.xaml docs/a.md
t "code-behind is T2 (unmatched)"      T2 src/Sprout.App/MainPage.xaml.cs
t "core logic is T2"                   T2 src/Sprout.Core/Greeting.cs
t "csproj is T3"                       T3 src/Sprout.App/Sprout.App.csproj
t "test csproj is T3, not test-only"   T3 tests/Sprout.Tests/Sprout.Tests.csproj
t "workflow is T3"                     T3 .github/workflows/pr.yml
t "PR template is T3 not T0"           T3 .github/pull_request_template.md
t "scripts are T3"                     T3 scripts/ci-gate.sh
t "plist is T3"                        T3 src/Sprout.App/Platforms/iOS/Info.plist
t "manifest is T3"                     T3 src/Sprout.App/Platforms/Android/AndroidManifest.xml
t "highest tier wins"                  T3 docs/a.md src/Sprout.Core/Greeting.cs .github/CODEOWNERS
t "rename scored by both paths"        T3 docs/new-name.md scripts/old-name.sh
t "no paths fails safe to T3"          T3
t "path with spaces and quotes"        T2 'src/Sprout.Core/it'"'"'s a file.cs'
RISK_MAP=/nonexistent ./scripts/risk-score.sh <<<"docs/a.md" | grep -qx T3 && echo "pass  missing rules file fails safe" || { echo "FAIL  missing rules file"; fail=1; }
printf 'T9 *.md\n' > /tmp/bad-risk-map.$$; RISK_MAP=/tmp/bad-risk-map.$$ ./scripts/risk-score.sh <<<"docs/a.md" | grep -qx T3 && echo "pass  malformed rules file fails safe" || { echo "FAIL  malformed rules file"; fail=1; }; rm -f /tmp/bad-risk-map.$$
# Canary: the harness must be able to fail.
[[ "$(echo docs/a.md | ./scripts/risk-score.sh)" == T3 ]] && { echo "FAIL  canary: docs scored T3"; fail=1; } || echo "pass  canary"
exit $fail
