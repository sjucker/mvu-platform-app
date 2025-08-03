import 'package:flutter/material.dart';
import 'package:mvu_platform/dto/absenz.dart';
import 'package:mvu_platform/service/events_service.dart';

class AbsenzCard extends StatefulWidget {
  const AbsenzCard(this._absenz);

  final Absenz _absenz;

  @override
  State<StatefulWidget> createState() {
    return _AbsenzCardState(_absenz);
  }
}

class _AbsenzCardState extends State<AbsenzCard> {
  _AbsenzCardState(this.absenz);

  Absenz absenz;
  late TextEditingController _commentController = TextEditingController(text: absenz.remark);
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _focusNode.addListener(() {
      if (!_focusNode.hasFocus) {
        updateComment();
      }
    });
  }

  void updateComment() {
    if (absenz.remark != _commentController.text) {
      setState(() {
        absenz.remark = _commentController.text;
      });
      update(context);
    }
  }

  @override
  void dispose() {
    _commentController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Row(children: <Widget>[Text(absenz.title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18))]),
          Row(
            children: <Widget>[
              Flexible(child: Text(absenz.subtitle)),
              if (absenz.interna.isNotEmpty) ...[Tooltip(message: absenz.interna, child: Icon(Icons.info_outline), padding: EdgeInsets.all(12))],
            ],
          ),
          Row(
            children: <Widget>[
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(12),
                  shape: const RoundedRectangleBorder(borderRadius: BorderRadiusDirectional.horizontal(start: Radius.circular(8))),
                  foregroundColor: _buttonColor(context, AbsenzState.POSITIVE, Colors.green[Theme.of(context).brightness == Brightness.dark ? 900 : 500]),
                ),
                onPressed: () {
                  setState(() {
                    absenz.status = AbsenzState.POSITIVE;
                  });
                  update(context);
                },
                child: Text('anwesend', style: TextStyle(color: _buttonTextColor(AbsenzState.POSITIVE))),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(12),
                  shape: const RoundedRectangleBorder(),
                  foregroundColor: _buttonColor(context, AbsenzState.NEGATIVE, Colors.red[Theme.of(context).brightness == Brightness.dark ? 900 : 500]),
                ),
                onPressed: () {
                  setState(() {
                    absenz.status = AbsenzState.NEGATIVE;
                  });
                  update(context);
                },
                child: Text('abwesend', style: TextStyle(color: _buttonTextColor(AbsenzState.NEGATIVE))),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(12),
                  shape: const RoundedRectangleBorder(borderRadius: BorderRadiusDirectional.horizontal(end: Radius.circular(8))),
                  foregroundColor: _buttonColor(context, AbsenzState.INACTIVE, Colors.grey),
                ),
                onPressed: () {
                  setState(() {
                    absenz.status = AbsenzState.INACTIVE;
                  });
                  update(context);
                },
                child: Text('inaktiv', style: TextStyle(color: _buttonTextColor(AbsenzState.INACTIVE))),
              ),
            ],
          ),
          Row(
            children: <Widget>[
              Flexible(
                child: TextField(
                  onSubmitted: (String value) {
                    updateComment();
                  },
                  decoration: const InputDecoration(labelText: 'Bemerkung'),
                  controller: _commentController,
                  focusNode: _focusNode,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void update(BuildContext context) {
    updateAbsenz(absenz)
        .then((_) => showSnackbar(context, 'gespeichert', Colors.green[Theme.of(context).brightness == Brightness.dark ? 900 : 500]))
        .catchError((Object e) => showSnackbar(context, 'Speichern fehlgeschlagen: $e', Colors.red));
  }

  void showSnackbar(BuildContext context, String text, Color? backgroundColor) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text), backgroundColor: backgroundColor));
  }

  Color? _buttonColor(BuildContext text, AbsenzState state, Color? color) =>
      absenz.status == state ? color : Colors.grey[Theme.of(context).brightness == Brightness.dark ? 600 : 100];

  Color? _buttonTextColor(AbsenzState state) => absenz.status == state ? Colors.white : Colors.black;
}
