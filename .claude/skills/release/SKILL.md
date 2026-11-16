---
name: release
description: Bump the app version, build the Android app bundle and the iOS IPA for a store release, then commit and tag the version bump. Use when asked to release, build a new version, or prepare a store upload. Takes major, minor or patch to say how the version changes.
argument-hint: "[major|minor|patch]"
---

# Release a new version

Bump type requested: `$ARGUMENTS`

Build a store release of the app for both Android and iOS. The upload to the stores is manual and is not part of this skill.

## 1. Work out the new version

Read `version:` in `pubspec.yaml`. It has the form `x.y.z+build`.

The build number goes up by exactly 1 on every release, whatever the bump type. Both stores reject a build number they have already seen, so never reuse or
reset it.

| Bump type  | `x.y.z` becomes | Example from `1.0.9+17` |
|------------|-----------------|-------------------------|
| `major`    | `(x+1).0.0`     | `2.0.0+18`              |
| `minor`    | `x.(y+1).0`     | `1.1.0+18`              |
| `patch`    | `x.y.(z+1)`     | `1.0.10+18`             |
| none given | unchanged       | `1.0.9+18`              |

With no bump type, only the build number changes. That is the right choice for re-uploading a version that was built but not yet released. If the argument is
anything other than `major`, `minor`, `patch` or empty, stop and ask which one is meant.

Write the new value to `pubspec.yaml` and tell the user the old and new version before building.

## 2. Check before building

Run these from the repository root and stop if any of them fails:

```sh
flutter pub get
dart format --output=none --set-exit-if-changed lib
flutter analyze
flutter test
```

Also check that Android signing is in place: `android/key.properties` and `key.jks` in the repository root must both exist. Without them the app bundle cannot
be signed for the Play Store. Never commit either file.

Mention uncommitted changes other than the version bump, because they end up in the build.

## 3. Build

Build both platforms, one after the other. Each build takes several minutes, so use a long timeout.

```sh
flutter build appbundle
flutter build ipa
```

If one platform fails, still build the other and report both results.

If the iOS build fails on stale packages, run `flutter clean` and `flutter pub get`, then build again. If that does not help, ask before deleting
`~/Library/Developer/Xcode/DerivedData`.

Read the build output for warnings, such as the app icon and launch image validation in `flutter build ipa`, and pass them on.

## 4. Commit and tag

Do this step only if all checks passed and both builds succeeded. If anything failed, leave the version bump in `pubspec.yaml` uncommitted, create no tag, and
say so in the report.

Commit only `pubspec.yaml`, on the current branch, then tag that commit with the full version prefixed by `v`:

```sh
git add pubspec.yaml
git commit -m "Bump version to x.y.z+build"
git tag vx.y.z+build
```

Leave other uncommitted or untracked files out of the commit. If the tag already exists, stop and ask instead of moving it. Do not push the commit or the tag
unless the user asks.

## 5. Report

Say for each platform whether the build succeeded, and give the version that was built. Give the commit hash and the tag name, or say that nothing was
committed and why. Then give the upload steps, which the user does by hand:

- Android: upload `build/app/outputs/bundle/release/app-release.aab` to the Play Console.
- iOS: upload `build/ios/ipa/mvu_platform.ipa` with the Apple Transporter app.

Remind the user that the commit and the tag are local until pushed (`git push --follow-tags` does not push lightweight tags, so use
`git push && git push origin vx.y.z+build`).
