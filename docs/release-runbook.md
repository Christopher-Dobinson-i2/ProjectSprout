# Release runbook (DRAFT)

**Status: draft, written before signing exists.** Steps marked (verify) rest on how Apple and Google normally
behave and must be checked against the real setup once issues #7, #8 and #9 are built. Needs a second person
to review before it counts (issue #13).

Roles, not people: **Release owner** (runs this), **Account owner** (holds the Apple and Google admin logins; two named people per account).

## Before anything goes wrong

- Know when each credential expires. Put every date in a shared calendar:
  - Apple distribution certificate (1 year)
  - Apple provisioning profiles (1 year)
  - App Store Connect API key (no expiry, but revocable)
  - Google Play upload key (long-lived; check the date at creation)
  - Play service account key (rotate on a schedule)
- Every signing secret has an owner, a backup and a rotation date in `docs/environments.md`.
- Never fix signing by hand on a laptop. Fix it in the pipeline, so the fix is repeatable.

## 1. Apple certificate or profile expired (iOS build fails to sign)

1. Confirm: the build error names the certificate or profile and an expiry.
2. Release owner asks the Account owner to approve a new certificate in the Apple Developer portal.
3. Regenerate through Fastlane `match` so the new certificate lands in the encrypted certificates repo. (verify)
4. Update the CI secret if the passphrase or token changed.
5. Rebuild the last release tag, not a new commit, so the shipped code is unchanged.
6. Record the new expiry date in the calendar.

Already-installed apps keep working when a certificate expires. Only new builds are blocked.

## 2. A key is revoked, leaked or suspected leaked

Treat as an incident. Speed matters more than tidiness.

1. Revoke it at the source now: App Store Connect API key, or the Play service account key, or the keystore if a copy left your control.
2. Rotate the CI secret in the GitHub Environment and rerun the pipeline.
3. Check the repo history and recent runs for the secret (GitHub secret scanning is on; also search the logs).
4. If the Android **upload** key is lost or leaked: ask Google Play support to reset the upload key. Play App Signing holds the real app signing key, so users are not affected. (verify)
5. Write down what happened and when. Tell the Account owner.

## 3. A store rejects the build

1. Read the rejection message in App Store Connect or the Play Console. Do not guess.
2. Fix the cause in a normal PR (labelled by risk tier) and ship a new build. Do not argue a rejection without reading the guideline cited.
3. If the rejection is a policy question (data collection, privacy answers), the Account owner answers it, not the pipeline.
4. Keep the previous good build live. Never halt a rollout without saying so.

## 4. A bad build is already live

1. Stop the staged rollout (Play Console) or remove the build from sale and phased release (App Store Connect). (verify)
2. Ship a fix forward as a new build number. You cannot un-publish a version number.
3. If crash reporting (Sentry) shows the failure, link the issue in the incident note.
4. Within a day: what slipped through, and which check should have caught it. File an issue.

## 5. CI is down or the account is blocked

1. Check GitHub status and the Actions billing page first. A failed payment stops every job (this happened on 2026-10-21).
2. Local fallback: a Mac with the pinned toolchain (`docs/toolchain.md`) can build. Signing material still has to come from the vault, never a loose file.
3. Do not push around branch protection. It is the thing that protects `main`.

## Contacts and access

To fill in: Account owner names, escalation route, who may approve a production deployment.
