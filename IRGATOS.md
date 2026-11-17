# Irgatos iPhone app (built on Codync)

This repository is a fork of [Codync](https://github.com/leepokai/Codync) (Apache 2.0, see
`LICENSE` and `NOTICE`). It builds the **Irgatos** iPhone app, which pairs with the Irgatos Mac
app: Irgatos speaks Codync's phone-host protocol (`vendor/codync/phone-link` in
[wegvon/irgatos](https://github.com/wegvon/irgatos)). The Codync name, logo and Codync Cloud are
not used (`TRADEMARK.md`).

## What differs from upstream

Kept small so upstream merges stay easy. Everything else is upstream as it is.

| Where | Change |
| --- | --- |
| `apps/project.yml` | App name Irgatos, bundle ids `com.wegvon.irgatos.*`, app group, keychain group, URL scheme `irgatos`, `DEVELOPMENT_TEAM` left for you, analytics `off`, no push relay yet (`none`), local network text |
| `apps/shared/Config/*.plist` | No Clerk key, no cloud URL: the app runs signed out and reaches the Mac directly or through your own relay |
| `apps/ios/**/Info.plist` | `CodyncPostHogKey`, `CodyncPushRelayURL` from the build settings |
| `AppEnvironment.swift` | App group and URL scheme read from Info.plist (upstream's values stay the fallback) |
| `Analytics.swift` | Key read from Info.plist; `off` turns analytics off |
| `SharedStore.swift`, `Push.swift` | Push relay URL read from Info.plist; `none` registers no push |
| `L10n.swift` | Text that says Codync shows the app's own name |
| `CodyncWidgets.swift`, `ComputersView.swift` | Two texts that bypass `L10n` go through it |
| `PairingView.swift` | Website link |
| `AppIcon.appiconset` | Irgatos icon |

## Build (once the Apple Developer account is active)

1. `brew install xcodegen`, then set `DEVELOPMENT_TEAM` in `apps/project.yml` to your team id.
2. `xcodegen generate --spec apps/project.yml` and open `apps/Codync.xcodeproj`.
3. Scheme **iOS**, your iPhone, Run. Xcode registers the bundle ids, app group and keychain group
   for the team on first build (automatic signing).
4. TestFlight: Product › Archive, Distribute App › TestFlight (internal testing).

In Irgatos on the Mac: Settings › Connections › iPhone app › Turn on › Pair iPhone, and scan.

## Updating from upstream

```sh
git fetch upstream
git merge upstream/main
tools/irgatos-check.sh   # every fork change still in place
```

Keep the phone and the Mac in step: `VERSION` in Irgatos' `src/features/phone-link/model/phoneLink.ts`
names the Codync release the Mac answers as (its `hello`), and `vendor/codync/UPSTREAM` the commit
the Mac's protocol code came from. After a merge that raises the app's `minHost`, update those too.

## Not yet

Push notifications (needs an APNs key from the Apple account and our own `relay/` Worker).
Then set `CODYNC_PUSH_RELAY_URL` in `apps/project.yml`.
