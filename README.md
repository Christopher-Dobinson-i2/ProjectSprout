# ProjectSprout

New .NET MAUI app for iOS and Android (`net10.0-ios;net10.0-android`).

Status: CI/CD foundations in progress. Work is tracked in GitHub Issues; start at the epic
"CI/CD foundations" (#15).

## Ground rules

- Changes reach `main` through a pull request. The first scaffold commit is the only exception.
- Every PR names its issue and risk tier (see the PR template).
- Never commit signing keys, keystores, certificates or API keys. `.gitignore` blocks the common ones; CI secrets live in the vault.
- Test and demo data is synthetic only.
