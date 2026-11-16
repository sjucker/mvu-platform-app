import 'dart:async';
import 'dart:io';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:mvu_platform/service/messaging_service.dart';
import 'package:permission_handler/permission_handler.dart';

StreamSubscription<String>? _registrationSubscription;
StreamSubscription<User?>? _authSubscription;

/// Latest Firebase Installation ID (FID) reported by [FirebaseMessaging.onRegistered].
String? _fid;

/// "uid:fid" of the last upload, so the same pair is not sent twice.
String? _uploadedFor;

Future<bool> requestPermissionAndSubscribe(bool force) async {
  if (await Permission.notification.isPermanentlyDenied && !force) {
    return false;
  }

  if (await Permission.notification.isGranted) {
    subscribeTo("general");
    return true;
  }

  var status = await Permission.notification.request();
  if (status.isGranted) {
    subscribeTo("general");

    await FirebaseAnalytics.instance.logEvent(name: "fcm_authorized");

    return true;
  }
  return false;
}

/// Registers this app instance for direct-send messaging. The Firebase
/// Installation ID (FID) arrives asynchronously via [FirebaseMessaging.onRegistered],
/// so the listener must be attached before calling register().
///
/// Registration usually completes during startup, before anyone is signed in, and
/// the backend call needs a signed-in user. The FID is therefore kept and sent as
/// soon as a user is available, and again when a different user signs in.
Future<void> registerForDirectMessaging() async {
  _registrationSubscription ??= FirebaseMessaging.instance.onRegistered.listen(
    (fid) {
      _fid = fid;
      _uploadFid();
    },
    onError: (Object error, StackTrace stack) {
      FirebaseCrashlytics.instance.recordError(error, stack);
    },
  );
  _authSubscription ??= FirebaseAuth.instance.authStateChanges().listen((_) => _uploadFid());

  await FirebaseMessaging.instance.register();
}

Future<void> _uploadFid() async {
  final fid = _fid;
  final uid = FirebaseAuth.instance.currentUser?.uid;
  if (fid == null || uid == null) {
    return;
  }

  final key = '$uid:$fid';
  if (_uploadedFor == key) {
    return;
  }
  _uploadedFor = key;

  try {
    await updateFid(fid);
  } catch (error, stack) {
    // allow a retry on the next registration or sign-in event
    if (_uploadedFor == key) {
      _uploadedFor = null;
    }
    FirebaseCrashlytics.instance.recordError(error, stack);
    return;
  }

  try {
    await FirebaseAnalytics.instance.logEvent(name: "fcm_registered");
  } catch (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack);
  }
}

void subscribeTo(String topic) async {
  // Topic subscription and direct-send registration are independent: a failure of
  // one (offline start, missing APNs token) must not skip the other, and neither
  // may escape as an unhandled error, which would be reported as a fatal crash.
  try {
    // make sure APNs token is available, otherwise wait some time
    if (Platform.isIOS) {
      String? apnsToken = await FirebaseMessaging.instance.getAPNSToken();
      if (apnsToken == null) {
        // wait a little bit and then try again
        await Future<void>.delayed(const Duration(seconds: 2));
        apnsToken = await FirebaseMessaging.instance.getAPNSToken();
        if (apnsToken == null) {
          FirebaseCrashlytics.instance.log("could not receive APNs in given time.");
        }
      }
    }

    await FirebaseMessaging.instance.subscribeToTopic(topic);
  } catch (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack);
  }

  try {
    await registerForDirectMessaging();
  } catch (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack);
  }
}

void unsubscribeFrom(String topic) async {
  await FirebaseMessaging.instance.unsubscribeFromTopic(topic);
}
