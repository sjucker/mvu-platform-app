import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

class VersionNumber extends StatelessWidget {
  const VersionNumber({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: PackageInfo.fromPlatform().then((PackageInfo packageInfo) {
        return '${packageInfo.version}+${packageInfo.buildNumber}';
      }),
      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.active:
          case ConnectionState.waiting:
            return LinearProgressIndicator();
          case ConnectionState.done:
            return Text('Version: ${snapshot.data}');
        }
      },
    );
  }
}
