import 'package:add_2_calendar_new/add_2_calendar_new.dart';
import 'package:flutter/material.dart';
import 'package:mvu_platform/dto/absenz.dart';
import 'package:mvu_platform/service/events_service.dart';

class AbsenzCard extends StatefulWidget {
  const AbsenzCard(this._absenz, {super.key});

  final Absenz _absenz;

  @override
  State<StatefulWidget> createState() {
    return _AbsenzCardState();
  }
}

class _AbsenzCardState extends State<AbsenzCard> {
  late final TextEditingController _commentController = TextEditingController(text: widget._absenz.remark);
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
    if (widget._absenz.remark != _commentController.text) {
      setState(() {
        widget._absenz.remark = _commentController.text;
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
    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            Expanded(
              child: Text(widget._absenz.title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            ),
            IconButton(
              onPressed: () {
                final Event event = Event(
                  title: widget._absenz.simpleTitle,
                  location: widget._absenz.location,
                  startDate: widget._absenz.from,
                  endDate: widget._absenz.to,
                );
                Add2Calendar.addEvent2Cal(event);
              },
              icon: Icon(Icons.calendar_month),
            ),
          ],
        ),
        Row(children: <Widget>[Expanded(child: Text(widget._absenz.subtitle))]),
        if (widget._absenz.interna.isNotEmpty) ...[
          ExpansionTile(
            tilePadding: EdgeInsetsGeometry.zero,
            childrenPadding: EdgeInsetsGeometry.zero,
            leading: Icon(Icons.info_outline),
            title: Text("Details"),
            dense: true,
            children: [ListTile(title: Text(widget._absenz.interna))],
          ),
        ],
        if (!widget._absenz.infoOnly) ...[
          Row(
            children: <Widget>[
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(12),
                  shape: const RoundedRectangleBorder(borderRadius: BorderRadiusDirectional.horizontal(start: Radius.circular(8))),
                  backgroundColor: _buttonColor(context, AbsenzState.positive, Colors.green[Theme.of(context).brightness == Brightness.dark ? 900 : 500]),
                ),
                onPressed: () {
                  setState(() {
                    widget._absenz.status = AbsenzState.positive;
                  });
                  update(context);
                },
                child: Text('anwesend', style: TextStyle(color: _buttonTextColor(AbsenzState.positive))),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(12),
                  shape: const RoundedRectangleBorder(),
                  backgroundColor: _buttonColor(context, AbsenzState.negative, Colors.red[Theme.of(context).brightness == Brightness.dark ? 900 : 500]),
                ),
                onPressed: () {
                  setState(() {
                    widget._absenz.status = AbsenzState.negative;
                  });
                  update(context);
                },
                child: Text('abwesend', style: TextStyle(color: _buttonTextColor(AbsenzState.negative))),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(12),
                  shape: const RoundedRectangleBorder(borderRadius: BorderRadiusDirectional.horizontal(end: Radius.circular(8))),
                  backgroundColor: _buttonColor(context, AbsenzState.inactive, Colors.grey),
                ),
                onPressed: () {
                  setState(() {
                    widget._absenz.status = AbsenzState.inactive;
                  });
                  update(context);
                },
                child: Text('inaktiv', style: TextStyle(color: _buttonTextColor(AbsenzState.inactive))),
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
      ],
    );
  }

  void update(BuildContext context) {
    updateAbsenz(widget._absenz)
        .then((_) => {if (context.mounted) showSnackbar(context, 'gespeichert', Colors.green[Theme.of(context).brightness == Brightness.dark ? 900 : 500])})
        .catchError((Object e) => {if (context.mounted) showSnackbar(context, 'Speichern fehlgeschlagen: $e', Colors.red)});
  }

  void showSnackbar(BuildContext context, String text, Color? backgroundColor) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text), backgroundColor: backgroundColor));
  }

  Color? _buttonColor(BuildContext text, AbsenzState state, Color? color) =>
      widget._absenz.status == state ? color : Colors.grey[Theme.of(context).brightness == Brightness.dark ? 600 : 100];

  Color? _buttonTextColor(AbsenzState state) => widget._absenz.status == state ? Colors.white : Colors.black;
}
