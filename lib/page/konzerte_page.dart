import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mvu_platform/dto/konzert.dart';
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
        padding: const .all(16),
        child: FutureBuilder(
          future: futureKonzerte,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView(
                children: snapshot.requireData
                    .map(
                      (entry) => ListTile(
                        title: Text(entry.name),
                        trailing: const Icon(Icons.keyboard_arrow_right_sharp),
                        onTap: () => context.go('/konzert-detail/${entry.id}'),
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
      drawer: const MvuNavigationDrawer(),
    );
  }
}
