# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project

Flutter mobile app (Android/iOS, portrait only) for the Musikverein Harmonie Urdorf. It is a thin client for the backend at `https://platform.mvurdorf.ch` (see `lib/service/base_service.dart`). Domain terms are in German and are used as-is in class and file names: *Absenz* (absence/attendance for an event), *Konzert* (concert), *Repertoire*, *Marschbuch*, *Tenü* (dress code).

## Commands

```sh
flutter pub get
dart format lib                     # page_width 160 (analysis_options.yaml); CI fails on unformatted code
flutter analyze                     # lints: flutter_lints + rules in analysis_options.yaml
flutter test                        # all tests in test/
flutter test test/<file>_test.dart  # single file; add --plain-name "<test name>" for one test
flutter run
dart run flutter_launcher_icons     # regenerate icons from flutter_launcher_icons.yaml
```

CI (`.github/workflows/flutter-ci.yml`) runs format check, analyze and tests on pushes to `main`/`develop` and on PRs. It installs the exact Flutter version from `environment.flutter` in `pubspec.yaml`, so keep that an exact version (no `^`) and bump it when upgrading Flutter. CI replaces `lib/firebase_options.dart` with a stub.

Tests cover DTO JSON parsing/serialization (`test/dto/`, using realistic JSON strings so int/double typing matches the wire) and widget rendering (`test/widget/`). Services call Firebase Auth and `http` directly and can't be unit-tested without injecting a client, so widget tests must not trigger backend calls (e.g. tapping `AbsenzCard` status buttons). Pumping `MvuApp` would need Firebase mocked and a `ThemeNotifier` provider.

Release (from README):
- Android: `flutter build appbundle`, then upload `build/app/outputs/bundle/release/app-release.aab` to the Play Console. Signing needs `android/key.properties` (storePassword, keyPassword, keyAlias=key, storeFile=../../key.jks). `key.jks` is in the repo root and must never be committed.
- iOS: `flutter build ipa`, then upload `build/ios/ipa/mvu_platform.ipa` with Apple Transporter. If the build breaks, run `flutter clean`, `flutter pub get`, then `cd ios && pod install --repo-update`.
- Bump `version:` in `pubspec.yaml` (`x.y.z+build`) for each store release.

Firebase config (`lib/firebase_options.dart`, `android/app/google-services.json`, `firebase.json`) is generated with `flutterfire configure --project=mvu-platform` (needs `firebase login` and `dart pub global activate flutterfire_cli`).

## Architecture

- **Startup (`lib/main.dart`)**: initializes Firebase, sends Flutter and platform errors to Crashlytics, requests notification permission, and subscribes to the `general` FCM topic. It then loads the dark-theme preference and runs `MvuApp` inside a `ChangeNotifierProvider<ThemeNotifier>`. The home widget is a `StreamBuilder` on `FirebaseAuth.authStateChanges()`: signed-in users see `AbsenzenPage`, everyone else sees `LoginPage`.
- **Auth**: Firebase Auth (email/password) is the only identity. Every backend call sends the current user's Firebase ID token as `Authorization: Bearer ...` through `getHeaders()` in `base_service.dart`.
- **Services (`lib/service/`)**: plain top-level async functions, not classes. They call `http` against `$baseUrl/api/secured/...` and decode with `utf8.decode(response.bodyBytes)` so umlauts survive. On a non-200 response they throw or return `Future.error`. `firebase_messaging.dart` handles permission and topic subscription and posts the FCM token to the backend through `messaging_service.dart`. `preference_service.dart` stores settings in SharedPreferences.
- **DTOs (`lib/dto/`)**: hand-written `fromJson` factories, plus `toJson` only for payloads that are sent (e.g. `Absenz`, the FCM token). No code generation.
- **UI**: `lib/page/` holds the screens; each is a `StatefulWidget` that fetches data in `initState` into a `Future` and renders it with `FutureBuilder`. `lib/widget/` holds reusable pieces. Navigation goes through the drawer (`widget/navigation_drawer.dart`) using `Navigator.push`. The only named route is `/reset-password`.
- **Theming**: Material 3 `ColorScheme.fromSeed` with `mvuRed` (`lib/constants.dart`). `ThemeNotifier` (Provider) switches light and dark mode at runtime.

## Conventions

- Recent Dart features are in use, such as dot shorthands (`const .all(16)`); the minimum versions are Dart `^3.14.0` and Flutter `^3.50.0`.
- Lint rules that are enforced on top of the defaults: `avoid_print`, `prefer_const_constructors`, `prefer_final_fields`, `annotate_overrides`, `use_key_in_widget_constructors`.
- Imports use the `package:mvu_platform/...` form.
