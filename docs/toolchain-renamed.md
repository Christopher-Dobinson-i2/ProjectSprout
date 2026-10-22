# Toolchain

Pinned so local and CI builds match. Change these deliberately, in their own PR.

| Tool | Version | Where pinned |
|---|---|---|
| .NET SDK | 10.0.302 | `global.json` |
| MAUI workload | 10.0.20/10.0.100 manifest (SDK band 10.0.300) | CI installs the same version; check `dotnet workload list` |
| Xcode | 26.6 (build 17F113) | CI macOS runner must select this version |
| Android SDK | platform-tools, build-tools, platforms via `-t:InstallAndroidDependencies` | local: `~/Library/Android/sdk` |
| JDK | 17 | `JAVA_HOME` |

## Build commands

```bash
dotnet test tests/Sprout.Tests
dotnet build src/Sprout.App -f net10.0-ios -p:EnableCodeSigning=false -p:RuntimeIdentifier=iossimulator-arm64
dotnet build src/Sprout.App -f net10.0-android -p:AndroidSdkDirectory=$HOME/Library/Android/sdk
```

Android SDK install (one-off):
`dotnet build src/Sprout.App -f net10.0-android -t:InstallAndroidDependencies -p:AndroidSdkDirectory=$HOME/Library/Android/sdk -p:AcceptAndroidSDKLicenses=True`

## Placeholders

- `ApplicationId` is `com.example.sprout` until the bundle ID is chosen (issue #2).
- Windows target removed; Mac Catalyst target kept for the demo build (issue #14).
