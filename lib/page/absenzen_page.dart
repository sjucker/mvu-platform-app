import 'package:flutter/material.dart';
import 'package:mvu_platform/widget/absenzen_list.dart';
import 'package:mvu_platform/widget/navigation_drawer.dart';

class AbsenzenPage extends StatelessWidget {
  const AbsenzenPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Absenzen')),
      body: Container(padding: const .all(16), child: const AbsenzenList()),
      drawer: const MvuNavigationDrawer(),
    );
  }
}
