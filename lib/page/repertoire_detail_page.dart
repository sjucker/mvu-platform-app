import 'package:flutter/material.dart';
import 'package:mvu_platform/dto/repertoire.dart';
import 'package:mvu_platform/service/repertoire_service.dart';
import 'package:url_launcher/url_launcher_string.dart';

class RepertoireDetailPage extends StatefulWidget {
  final RepertoireType repertoireType;

  const RepertoireDetailPage({super.key, required this.repertoireType});

  @override
  State<RepertoireDetailPage> createState() => _RepertoireDetailPageState();
}

class _RepertoireDetailPageState extends State<RepertoireDetailPage> {
  late Future<Repertoire> futureRepertoire;

  @override
  void initState() {
    super.initState();
    futureRepertoire = getRepertoire(widget.repertoireType);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.repertoireType.description)),
      body: FutureBuilder<Repertoire>(
        future: futureRepertoire,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView(
              children: snapshot.requireData.entries
                  .map(
                    (entry) => ListTile(
                      leading: widget.repertoireType == RepertoireType.marschbuch ? Text(entry.number?.toStringAsFixed(0) ?? '') : null,
                      title: Text(entry.kompositionTitel),
                      subtitle: Text(entry.subtitle),
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
}
