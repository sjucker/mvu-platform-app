import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mvu_platform/constants.dart';
import 'package:mvu_platform/page/absenzen_page.dart';
import 'package:mvu_platform/page/change_password_page.dart';
import 'package:mvu_platform/page/konzerte_page.dart';
import 'package:mvu_platform/page/repertoire_page.dart';
import 'package:mvu_platform/service/dark_theme.dart';
import 'package:mvu_platform/service/preference_service.dart';
import 'package:mvu_platform/widget/version_number.dart';
import 'package:provider/provider.dart';

class MvuNavigationDrawer extends StatefulWidget {
  const MvuNavigationDrawer({super.key});

  @override
  State<StatefulWidget> createState() {
    return _MvuNavigationDrawerState();
  }
}

class _MvuNavigationDrawerState extends State<MvuNavigationDrawer> {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  late bool _darkTheme = false;

  @override
  void initState() {
    super.initState();
    isDarkTheme().then((value) {
      setState(() {
        _darkTheme = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          const DrawerHeader(
            decoration: BoxDecoration(color: mvuRed),
            child: Text('Musikverein Harmonie Urdorf', style: TextStyle(color: Colors.white, fontSize: 24)),
          ),
          SwitchListTile(
            title: Text('Dark Theme'),
            secondary: _darkTheme ? const Icon(Icons.lightbulb_outlined) : const Icon(Icons.lightbulb),
            value: _darkTheme,
            onChanged: (bool value) {
              setState(() {
                _darkTheme = value;
              });
              themeNotifier.switchTheme();
              setDarkTheme(value);
            },
          ),
          ListTile(
            leading: const Icon(Icons.calendar_month),
            title: const Text('Absenzen'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (context) => const AbsenzenPage()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.queue_music),
            title: const Text('Konzerte'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (context) => const KonzertePage()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.list),
            title: const Text('Repertoire'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (context) => const RepertoirePage()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.lock_outline),
            title: const Text('Passwort ändern'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (context) => const ChangePasswordPage()));
            },
          ),
          ListTile(
            trailing: Icon(Icons.exit_to_app),
            title: const Text('Logout'),
            onTap: () {
              _firebaseAuth.signOut();
            },
          ),
          ListTile(title: VersionNumber()),
        ],
      ),
    );
  }
}
