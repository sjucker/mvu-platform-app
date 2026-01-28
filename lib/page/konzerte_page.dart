import 'package:flutter/material.dart';
import 'package:mvu_platform/dto/konzert.dart';
import 'package:mvu_platform/page/konzert_detail_page.dart';
import 'package:mvu_platform/service/konzerte_service.dart';
import 'package:mvu_platform/widget/navigation_drawer.dart';

class KonzertePage extends StatefulWidget {
  const KonzertePage({super.key});

  @override
  State<KonzertePage> createState() => _KonzertePageState();
}

class _KonzertePageState extends State<KonzertePage> {
  late Future<List<Konzert>> futureKonzerte;

  @override
  void initState() {
    super.initState();
    futureKonzerte = getKonzerte();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Konzerte')),
      body: Container(
        padding: const EdgeInsets.all(16),
        child: FutureBuilder(
          future: futureKonzerte,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView(
                children: snapshot.requireData
                    .map(
                      (entry) => ListTile(
                        title: Text(entry.name),
                        trailing: Icon(Icons.keyboard_arrow_right_sharp),
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => KonzertDetailPage(id: entry.id))),
                      ),
                    )
                    .toList(),
              );
            } else if (snapshot.hasError) {
              return Text('${snapshot.error}');
            }
            return const Center(child: CircularProgressIndicator());
          },
        ),
      ),
      drawer: MvuNavigationDrawer(),
    );
  }
}
