import 'dart:async';
import 'dart:io';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:mvu_platform/service/messaging_service.dart';
import 'package:permission_handler/permission_handler.dart';

StreamSubscription<String>? _registrationSubscription;

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

    await FirebaseAnalytics.instance.logEvent(name: "FirebaseMessaging: authorized");

    return true;
  }
  return false;
}

/// Registers this app instance for direct-send messaging. The Firebase
/// Installation ID (FID) arrives asynchronously via [FirebaseMessaging.onRegistered]
/// and is sent to the backend, so the listener must be attached before calling register().
Future<void> registerForDirectMessaging() async {
  _registrationSubscription ??= FirebaseMessaging.instance.onRegistered.listen(
    (fid) async {
      try {
        await updateFid(fid);
        await FirebaseAnalytics.instance.logEvent(name: "FirebaseMessaging: onRegistered");
      } catch (error, stack) {
        FirebaseCrashlytics.instance.recordError(error, stack);
      }
    },
    onError: (Object error, StackTrace stack) {
      FirebaseCrashlytics.instance.recordError(error, stack);
    },
  );

  await FirebaseMessaging.instance.register();
}

void subscribeTo(String topic) async {
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
  await registerForDirectMessaging();
}

void unsubscribeFrom(String topic) async {
  await FirebaseMessaging.instance.unsubscribeFromTopic(topic);
}
