# Mac demo build

Every merge to `main` that touches `src/` builds `Sprout.app` for Mac Catalyst and attaches it to the run as
the `Sprout-mac-demo` artifact (14 days). No Xcode needed to run it.

## Run it

1. Open the latest "Mac demo build" run in the Actions tab and download `Sprout-mac-demo`.
2. Unzip and double-click `Sprout.app`.
3. First launch: the app is not notarised, so macOS blocks it. Right-click, Open, Open. Or run
   `xattr -dr com.apple.quarantine Sprout.app`.

The window is fixed at 393 x 852 (phone size) so a demo looks like a phone.

## Signing decision

- **Inside the team:** ad-hoc signature, no Apple account needed. Use the first-launch steps above.
- **Outside the team:** needs a Developer ID Application certificate and notarisation, which needs the Apple
  Developer organisation account (issue #2). Until then, do not send the `.app` to people who cannot
  right-click Open. A TestFlight build (issue #9) is the better route for outside testers.
