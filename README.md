# MVU Platform

## Release

### Android

* `flutter build appbundle`
* Upload [app-release.aab](build/app/outputs/bundle/release/app-release.aab) to Play Console

### iOS

* `flutter build ipa`
* Upload [mvu_platform.ipa](build/ios/ipa/mvu_platform.ipa) using Apple Transporter macOS app

#### Troubleshooting

* `flutter clean`
* `flutter pub get`
* `flutter build ipa` (iOS plugins are resolved through Swift Package Manager during the build, `pod install` no longer updates them)
* If packages are still stale, delete `~/Library/Developer/Xcode/DerivedData` and build again

## Firebase

* `firebase login`
* `dart pub global activate flutterfire_cli`

* `$HOME/.pub-cache/bin/flutterfire configure --project=mvu-platform` (macOS)
* `& $env:userprofile\AppData\Local\Pub\Cache\bin\flutterfire.bat configure --project=mvu-platform` (Windows)

* Add `key.properties` to `/android`:
    * ```
  storePassword=<PASSWORD>
  keyPassword=<PASSWORD>
  keyAlias=key
  storeFile=../../key.jks
    ```
    * Make sure it points to the correct `key.jks` (this file must not be under version control!)

## Icons

* See [flutter_launcher_icons.yaml](flutter_launcher_icons.yaml)
* Run `dart run flutter_launcher_icons`
