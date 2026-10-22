# Environments

Three environments, defined in code. Nothing is created by hand.

| | dev | staging | production |
|---|---|---|---|
| Build flag | `-p:SproutEnv=dev` (default for local) | `-p:SproutEnv=staging` | `-p:SproutEnv=production` |
| Bundle / app ID | `<base>.dev` | `<base>.staging` | `<base>` |
| App name | Sprout Dev | Sprout Staging | Sprout |
| API URL | `SproutEnvironments.Dev` | `SproutEnvironments.Staging` | `SproutEnvironments.Production` |

Different bundle IDs mean all three install side by side on one phone.

- Config lives in `src/Sprout.Core/SproutEnvironment.cs` (URLs, tested) and the `SproutEnv` block in
  `src/Sprout.App/Sprout.App.csproj` (identity).
- The environment is baked in at build time. It is never read from a user-editable setting.
- A Release build must name its environment. An unknown name fails the build. No silent fallback to dev.
- The `<base>` bundle ID is the placeholder `com.example.sprout` until issue #2 settles it. Change `SproutBaseId` in one place.
- The API URLs use the reserved `.invalid` domain: they are placeholders and cannot resolve. Replace each when its backend exists.

## Which workflow builds which environment

| Workflow | Environment |
|---|---|
| PR checks, nightly | dev |
| Mac demo build | staging |
| Ship to testers (#9, not built yet) | staging on merge to `main`; production only on a version tag |

## GitHub Environments

`dev`, `staging` and `production` exist as GitHub Environments (created by `scripts/setup-github-environments.sh`,
so they can be recreated). `staging` and `production` only deploy from `main`. `production` needs a reviewer's approval.
Secrets are set per environment and never in the repo.

## Secrets plan

| Secret | Environment | Used by | Status |
|---|---|---|---|
| App Store Connect API key (id, issuer, .p8) | production, staging | #7 iOS signing | waiting on Apple account (#2) |
| Match certificate repo token + passphrase | production, staging | #7 | waiting on #2 |
| Android upload keystore + passwords | production, staging | #8 Android signing | waiting on Google account (#2) |
| Play service account JSON | production, staging | #9 | waiting on #2 |
| Sentry DSN | one per environment | #13 crash reporting | waiting on a Sentry account |
| Backend deploy credentials | per environment | backend pipeline | no backend yet |

**Vault decision (open):** GitHub Environment secrets are the store for now. When the backend exists, move runtime
secrets to a managed vault (Azure Key Vault if the backend is on Azure) and have the pipeline read them with
short-lived credentials. Build-time signing material can stay in GitHub Environment secrets.

## Not done yet

- A real backend per environment, deployed by a pipeline (no backend exists). Until then "staging app talks to staging backend" is only true of the configuration, not of a running service.
