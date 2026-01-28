import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mvu_platform/constants.dart';
import 'package:mvu_platform/firebase_options.dart';
import 'package:mvu_platform/page/absenzen_page.dart';
import 'package:mvu_platform/page/login_page.dart';
import 'package:mvu_platform/page/reset_password_page.dart';
import 'package:mvu_platform/service/dark_theme.dart';
import 'package:mvu_platform/service/firebase_messaging.dart';
import 'package:mvu_platform/service/preference_service.dart';
import 'package:provider/provider.dart';

Future<void> initFirebase() async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  // Pass all uncaught "fatal" errors from the framework to Crashlytics
  FlutterError.onError = (errorDetails) {
    FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
  };

  // Pass all uncaught asynchronous errors that aren't handled by the Flutter framework to Crashlytics
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };

  setupMessaging();

  await requestPermissionAndSubscribe(false);
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initFirebase();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  isDarkTheme().then((darkTheme) => runApp(ChangeNotifierProvider<ThemeNotifier>(create: (_) => ThemeNotifier(darkTheme), child: const MvuApp())));
}

Future<void> setupMessaging() async {
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    // TODO
  });

  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    // TODO
  });
}

class MvuApp extends StatelessWidget {
  const MvuApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);

    return MaterialApp(
      title: 'Musikverein Harmonie Urdorf',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: mvuRed, brightness: Brightness.light),
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: mvuRed, brightness: Brightness.dark),
      ),
      themeMode: themeNotifier.getTheme(),
      routes: <String, WidgetBuilder>{'/reset-password': (BuildContext context) => const ResetPasswordPage()},
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (BuildContext context, AsyncSnapshot<User?> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else {
            if (snapshot.hasData) {
              return const AbsenzenPage();
            } else {
              return const LoginPage();
            }
          }
        },
      ),
    );
  }
}
