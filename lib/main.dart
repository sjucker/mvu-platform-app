import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mvu_platform/page/absenzen_page.dart';
import 'package:mvu_platform/page/login_page.dart';
import 'package:mvu_platform/page/reset_password_page.dart';
import 'package:mvu_platform/service/dark_theme.dart';
import 'package:mvu_platform/service/preference_service.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  isDarkTheme().then((darkTheme) => runApp(ChangeNotifierProvider<ThemeNotifier>(create: (_) => ThemeNotifier(darkTheme), child: MvuApp())));
}

class MvuApp extends StatelessWidget {
  const MvuApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);

    return MaterialApp(
      title: 'Musikverein Harmonie Urdorf',
      theme: ThemeData.light(),
      darkTheme: ThemeData(brightness: Brightness.dark, primaryColor: Colors.lightBlue[800]),
      themeMode: themeNotifier.getTheme(),
      routes: <String, WidgetBuilder>{'/reset-password': (BuildContext context) => ResetPasswordPage()},
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (BuildContext context, AsyncSnapshot<User?> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else {
            if (snapshot.hasData) {
              return AbsenzenPage();
            } else {
              return LoginPage();
            }
          }
        },
      ),
    );
  }
}
