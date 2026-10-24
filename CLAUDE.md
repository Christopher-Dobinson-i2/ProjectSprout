# ProjectSprout

New .NET MAUI app for iOS and Android (plus a Mac Catalyst build for demos). Evidence capture for learners and
assessors, built to sit alongside OneFile's platform. This repo is separate from ProjectHelix
(`~/Vanguard/ProjectHelix`): do not copy Helix's gate rules, epic branches or vendor-PR process here.

## Where things live

| What | Where |
|---|---|
| Code | https://github.com/Christopher-Dobinson-i2/ProjectSprout (this repo; currently **public**) |
| App stories (the product backlog) | **Jira** project `SPRT`, site `dobbo1988.atlassian.net`, board 233. Start at epic **SPRT-1** "App foundation". |
| CI/CD work | **GitHub Issues** here, epic **#15**. Items #1 to #14 are labelled `[CICD-A]` to `[CICD-N]`. |
| Plan for the pipeline | https://claude.ai/artifact/Xykh5JpSXDi3qTfDRyiTun |
| Feature review the stories came from | https://claude.ai/artifact/4VkFzse4iQH8CN2sef6JHy (62 features, filter by shared/learner/assessor) |
| Handoff and how to connect | `docs/HANDOFF.md` |

Two trackers on purpose: Jira for product stories, GitHub Issues for pipeline work. Do not duplicate between them.

## Stack and layout

- .NET SDK pinned in `global.json` (10.0.302). Targets: `net10.0-ios;net10.0-android;net10.0-maccatalyst`.
- `src/Sprout.App` MAUI app. `src/Sprout.Core` plain `net10.0` logic (no MAUI types). `tests/Sprout.Tests` xUnit.
  Keep logic in Core so tests run on Linux in CI.
- Environments are code: `-p:SproutEnv=dev|staging|production` (see `docs/environments.md`). Release builds must
  name one. Bundle ID is the placeholder `com.example.sprout` until the Apple/Google accounts exist.
- Toolchain details: `docs/toolchain.md`. Xcode 26.6 is required locally and in CI.

## Commands

```bash
export PATH=$HOME/.dotnet:$PATH
dotnet test tests/Sprout.Tests
dotnet build src/Sprout.App -p:SproutTargets=net10.0-ios -p:EnableCodeSigning=false -p:RuntimeIdentifier=iossimulator-arm64
dotnet build src/Sprout.App -p:SproutTargets=net10.0-android -p:AndroidSdkDirectory=$HOME/Library/Android/sdk
./scripts/test-ci-gate.sh && ./scripts/test-risk-score.sh
actionlint          # after any workflow edit
```

## How to work

1. Pick a Jira story (or GitHub issue). Branch: `SPRT-<n>-<slug>` for Jira stories, `cicd-<x>-<slug>` for pipeline work.
2. Open a PR to `main`. Title `[SPRT-<n>] type: description`. Body starts `Jira: SPRT-<n>` (or `Closes #<n>`).
   Never push to `main` directly.
3. CI must be green: `ci-gate` is the only required check. It aggregates PR tests, Android and iOS builds, CodeQL and
   dependency review.
4. Every PR is auto-labelled `risk:t0` to `risk:t3` from the changed paths (`.github/risk-map.txt`). Declare the tier in
   the PR body. Round up when unsure. T3 means manifests, entitlements, csproj, signing, pipeline, gate files.
5. Tests go in the same PR. Show real output as evidence, never a claim.
6. Merge with `gh pr merge <n> --squash`, then check the PR is MERGED and `main` contains the change before deleting the
   branch (`gh api -X DELETE repos/Christopher-Dobinson-i2/ProjectSprout/git/refs/heads/<branch>`).
7. Tick acceptance-criteria boxes only for what is proven. Leave the rest open and say why.

## Rules that do not bend

- **Synthetic media only.** No real learner, child or nursery photo, audio or text anywhere: code, tests, fixtures, logs.
- No secrets in the repo, ever. Signing material and DSNs live in GitHub Environment secrets (see `docs/environments.md`).
- Never log tokens, passwords, media bytes or paths, file names, or free text. Crash events must carry no personal data.
- Changing the gate (`ci-gate`, `risk.yml`, `risk-map.txt`, branch protection, `scripts/`) needs the owner's recorded
  approval on the issue. Ask first.
- The risk workflow uses `pull_request_target`: it must never check out or run PR code.
- Services sit behind interfaces with in-memory fakes. No real backend exists yet.
- Match surrounding code style. Mirror OneFile's `*Service` / `Interfaces/` shape.

## Gotchas learned the hard way

- SSH to GitHub is refused for this account. Use HTTPS (`gh auth git-credential` is set as the credential helper).
- Mac Catalyst draws UI at 77%, so window sizes are divided by 0.77 in `App.xaml.cs`.
- macOS CI needs `runs-on: macos-26` with Xcode 26.6 selected explicitly (`macos-15` only has Xcode 16.4).
- iOS jobs must restore only iOS: pass `-p:SproutTargets=net10.0-ios`, not `-f`.
- Changing a PR's base branch does not trigger workflows. Close and reopen the PR.
- Branch protection requires `ci-gate` and an up-to-date branch. Several merges in a row each need a re-run.
- Dependabot opens many PRs. Batch them into one when possible.
- Actions billing failed once ("recent account payments have failed") and stopped every job. Check Billing first if
  all jobs fail in seconds.

## Open owner actions (not agent work)

Apple Developer and Google Play organisation accounts (#2). Sentry account and DSN (SPRT-16). Fix Actions billing and
buy GitHub Pro **before the repo goes private**, which is due before real feature code lands (decision 2026-10-22).
Choose Bicep or Terraform for the Azure backend (decision: backend is on Azure; secrets to Key Vault).
