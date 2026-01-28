import 'package:flutter/material.dart';
import 'package:mvu_platform/dto/repertoire.dart';
import 'package:mvu_platform/page/repertoire_detail_page.dart';
import 'package:mvu_platform/widget/navigation_drawer.dart';

class RepertoirePage extends StatelessWidget {
  const RepertoirePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Repertoire')),
      body: ListView.builder(
        itemCount: RepertoireType.values.length,
        itemBuilder: (context, index) {
          final repertoireType = RepertoireType.values[index];
          return ListTile(
            title: Text(repertoireType.description),
            trailing: const Icon(Icons.keyboard_arrow_right_sharp),
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => RepertoireDetailPage(repertoireType: repertoireType))),
          );
        },
      ),
      drawer: const MvuNavigationDrawer(),
    );
  }
}
