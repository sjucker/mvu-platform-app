import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mvu_platform/dto/konzert.dart';
import 'package:mvu_platform/service/konzerte_service.dart';
import 'package:url_launcher/url_launcher_string.dart';

class KonzertDetailPage extends StatefulWidget {
  final int id;

  const KonzertDetailPage({super.key, required this.id});

  @override
  State<KonzertDetailPage> createState() => _KonzertDetailPageState();
}

class _KonzertDetailPageState extends State<KonzertDetailPage> {
  late Future<Konzert> futureKonzert;

  @override
  void initState() {
    super.initState();
    futureKonzert = getKonzertById(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: FutureBuilder(
          future: futureKonzert,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Text(snapshot.requireData.name);
            }
            return const Text('Konzert');
          },
        ),
      ),
      body: FutureBuilder(
        future: futureKonzert,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var konzert = snapshot.requireData;
            return Column(
              children: [
                Text(dateTimeAndLocation(konzert)),
                Text(konzert.description ?? ""),
                Text(konzert.tenu ?? ""),
                Expanded(
                  child: ListView(
                    children: konzert.entries
                        .map(
                          (entry) => ListTile(
                            title: Text(entry.title),
                            leading: entry.zugabe ? Icon(Icons.waving_hand) : null,
                            trailing: entry.kompositionAudioSample != null
                                ? IconButton(
                                    onPressed: () async {
                                      final url = entry.kompositionAudioSample!;
                                      if (await canLaunchUrlString(url)) {
                                        await launchUrlString(url);
                                      }
                                    },
                                    icon: Icon(Icons.audio_file),
                                  )
                                : null,
                          ),
                        )
                        .toList(),
                  ),
                ),
              ],
            );
          } else if (snapshot.hasError) {
            return Text('${snapshot.error}');
          }

          // By default, show a loading spinner.
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  String dateTimeAndLocation(Konzert konzert) {
    var dateTime = DateFormat('dd.MM.yyyy, kk:mm').format(konzert.dateTime);
    if (konzert.location != null) {
      return '$dateTime, ${konzert.location}';
    } else {
      return dateTime;
    }
  }
}
