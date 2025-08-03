import 'package:flutter/material.dart';
import 'package:mvu_platform/dto/absenz.dart';
import 'package:mvu_platform/service/events_service.dart';
import 'package:mvu_platform/widget/absenz_card.dart';

class AbsenzenList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _AbsenzenListState();
  }
}

class _AbsenzenListState extends State<AbsenzenList> {
  _AbsenzenListState();

  Future<List<Absenz>> _absenzen = getAbsenzen();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Absenz>>(
      future: _absenzen,
      builder: (BuildContext context, AsyncSnapshot<List<Absenz>> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.active:
          case ConnectionState.waiting:
            return const Center(child: CircularProgressIndicator());
          case ConnectionState.done:
            if (snapshot.hasError) {
              return Center(
                child: Column(
                  children: <Widget>[
                    Text('Fehler: ${snapshot.error}'),
                    IconButton(
                      icon: Icon(Icons.refresh),
                      onPressed: () {
                        final Future<List<Absenz>> fetched = getAbsenzen();
                        setState(() {
                          _absenzen = fetched;
                        });
                      },
                    ),
                  ],
                ),
              );
            } else {
              return RefreshIndicator(
                onRefresh: () {
                  final Future<List<Absenz>> fetched = getAbsenzen();
                  setState(() {
                    _absenzen = fetched;
                  });
                  return fetched;
                },
                child: ListView.separated(
                  separatorBuilder: (BuildContext context, int index) => Divider(color: Colors.grey, height: 32),
                  itemCount: snapshot.requireData.length,
                  itemBuilder: (BuildContext context, int index) => AbsenzCard(snapshot.requireData[index]),
                ),
              );
            }
        }
      },
    );
  }
}
