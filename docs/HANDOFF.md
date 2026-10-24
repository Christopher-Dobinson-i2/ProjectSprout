# Handoff: start work in `~/Vanguard/OneFile/ProjectSprout`

Written 2026-10-24. Everything below was checked from the previous session unless marked (unverified).

## 1. Start a session here

```bash
cd ~/Vanguard/OneFile/ProjectSprout
claude
```

Start Claude Code **in this folder** so it reads `CLAUDE.md`. Memory and permissions are per folder, so a session started
in `ProjectHelix` will not know about this repo.

## 2. Git connection (checked)

- Remote: `https://github.com/Christopher-Dobinson-i2/ProjectSprout.git` (HTTPS).
- Credentials: `gh auth` account `Christopher-Dobinson-i2`, with `credential.helper = !gh auth git-credential` set in this repo.
- Commit email: `97096276+Christopher-Dobinson-i2@users.noreply.github.com` (set in this repo, so the work email is not
  used). Commits end with `Co-Authored-By: Claude ...`.
- SSH to GitHub is refused for this account. Do not switch the remote to SSH unless you add a key to the account.

Verify in one go:

```bash
gh auth status
git remote -v
git ls-remote origin HEAD            # prints a SHA = reads work
gh pr list --state open              # normally empty
gh api repos/Christopher-Dobinson-i2/ProjectSprout/branches/main/protection --jq '.required_status_checks.contexts'   # ["ci-gate"]
```

If `git push` asks for a password, run `gh auth setup-git` or re-run `gh auth login` choosing HTTPS.

## 3. Jira connection

- Site: `dobbo1988.atlassian.net` (cloud ID `87d8e7a8-d9e1-4ccb-8488-b77526933ade`). Project key: `SPRT`. Board: 233.
  https://dobbo1988.atlassian.net/jira/software/projects/SPRT/boards/233
- Connected through the **claude.ai Atlassian Rovo** connector (an account-level connector, not a per-folder setting).
  It already works for this account, so a new session in any folder gets it.
- **First connect is slow.** The first dial takes about 25 to 30 seconds, and `/mcp` reports "Request timed out" first.
  Wait, then run `/mcp` again; a second attempt connects. If the Atlassian tools are missing in a session, quit and start a
  fresh one: tools do not appear mid-session after a failed connect.
- Do not reuse `connecting-claude-desktop-to-atlassian-windows-v2.md`. That is for the Windows desktop app. A "blank page"
  when re-authenticating means authentication was not needed.
- The **HELIX** Jira project is a different, legacy board (211 open issues). Do not touch it. Work in `SPRT` only.

Verify in the new session by asking: *"Search Jira project SPRT for epic SPRT-1 and list its child stories with
priority and status."* Expect 17 stories, SPRT-2 to SPRT-18, all To Do, SPRT-2 `Highest`.

Issue types in SPRT: Epic, Story, Task, Bug, Subtask. Statuses: To Do, In Progress, In Review, Done (no "Won't Do"; use
Done plus a `wont-do` label and a comment).

### Linking Jira to GitHub

Not automatic yet. Until someone installs **GitHub for Jira** (needs a Jira site admin), link by convention:

- Branch `SPRT-<n>-<slug>`; PR title `[SPRT-<n>] ...`; PR body first line `Jira: SPRT-<n>`.
- When a PR merges, move the story to Done in Jira and comment the PR URL and merge SHA.
- Dependencies are real Jira "Blocks" links, so the board shows blocked stories.

## 4. State of play

| Area | State |
|---|---|
| Pipeline | PR checks (Android on Linux, iOS on macOS), `ci-gate`, branch protection, risk labels, CodeQL, dependency review, nightly build matrix, Mac demo build: all working. Environments dev/staging/production as code. |
| CI/CD issues | Done: #1, #3, #4, #6, #14. Waiting on the owner: #2 (Apple/Google accounts), then #7, #8, #9. Partly open: #5, #10, #11, #12, #13. Epic: #15. |
| Product backlog | Jira epic SPRT-1 with 17 stories. Nothing built yet. App is a skeleton ("Hello, Sprout!"). |
| Repo | Public. Decision: private before real feature code lands. Needs Actions billing fixed and GitHub Pro first. |

### Build order for SPRT-1

`SPRT-2` interfaces and fakes (do first) -> `SPRT-3` design system, `SPRT-10` org config, `SPRT-11` offline storage and sync,
`SPRT-16` diagnostics (any order) -> `SPRT-4` app shell -> `SPRT-5` sign-in -> `SPRT-6` MFA, `SPRT-7` account switching,
`SPRT-8` PIN/biometric, `SPRT-9` forgotten password -> `SPRT-12`, `SPRT-13`, `SPRT-14` capture -> `SPRT-15` upload queue ->
`SPRT-17` settings, `SPRT-18` version/update.

## 5. What the app contains when SPRT-1 is finished

**It is a working, tested chassis, not a product.** Running on iOS, Android and a Mac demo window, against in-memory fakes
(no real backend), it can:

- Show the OneFile look (design tokens, Open Sans), in the organisation's own terminology.
- Sign a user in with email and password, with MFA, forgotten-password and organisation single sign-on entry; keep the
  session in secure storage and renew it quietly.
- Unlock with a PIN or Face ID/fingerprint, including offline within an allowed window; switch accounts, show a profile,
  log out safely.
- Land each signed-in user on an **empty** dashboard for their role (learner or assessor).
- Capture a photo, record audio, or import a file; store it encrypted on the device, work fully offline, and sync and
  upload later through a resumable queue that never duplicates and survives an app kill.
- Report crashes to Sentry with no personal data, show a diagnostics view, a settings/help area, the version and
  environment, and block builds below a minimum version.

**It deliberately does not contain:** evidence gallery, editing, assignment or review (F15); anything specific to learners
or to assessors (21 and 22 features); video (F13); share/export (F16); disaster recovery (F47); framework or criteria
mapping; AI features; a real backend connection; store releases (needs signing, #7 to #9). Those wait until the user
workflow settles. Because every service is behind an interface, they can be built on top without reworking the chassis.

## 6. Suggested first prompt in the new session

> Read CLAUDE.md and docs/HANDOFF.md. Check the Jira and git connections as described in section 2 and 3. Then
> start SPRT-2 (service interfaces and in-memory fakes) on branch SPRT-2-service-interfaces. Show me the plan before
> writing code.

Before the first real feature code, settle the repo-visibility step (billing and GitHub Pro, then make it private).

## 7. Files left behind (not in this repo)

- `~/Vanguard/ProjectSprout-planning/` : the earlier draft backlog (`sprt-ci-cd-backlog.md`) and the script that filed
  it. **Superseded**: its "NOT YET FILED IN JIRA" header is out of date; the items were filed as GitHub Issues #1 to #15.
- The feature review and concept pages are Claude artifacts (links in `CLAUDE.md`). They are not committed here because
  they analyse OneFile's product and this repo is public.
