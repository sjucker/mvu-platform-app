import 'package:flutter/material.dart';
import 'package:mvu_platform/widget/absenzen_list.dart';

class AbsenzenPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: const Text('MVU Absenzen')), body: Container(padding: const EdgeInsets.all(16), child: AbsenzenList()));
  }
}
