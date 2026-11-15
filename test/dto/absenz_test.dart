import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mvu_platform/dto/absenz.dart';

Map<String, dynamic> absenzJson({String status = 'POSITIVE', String? remark = 'komme später'}) => json.decode('''
{
  "loginId": 7,
  "eventId": 42,
  "title": "Probe",
  "subtitle": "Mittwoch, 19:30",
  "interna": "Register Holz",
  "status": "$status",
  "remark": ${remark == null ? 'null' : '"$remark"'},
  "simpleTitle": "Probe MVU",
  "location": "Zentrum Urdorf",
  "from": "2026-11-18T19:30:00",
  "to": "2026-11-18T22:00:00",
  "infoOnly": false
}
''') as Map<String, dynamic>;

void main() {
  group('Absenz.fromJson', () {
    test('parses all fields', () {
      final absenz = Absenz.fromJson(absenzJson());

      expect(absenz.loginId, 7);
      expect(absenz.eventId, 42);
      expect(absenz.title, 'Probe');
      expect(absenz.subtitle, 'Mittwoch, 19:30');
      expect(absenz.interna, 'Register Holz');
      expect(absenz.status, AbsenzState.positive);
      expect(absenz.remark, 'komme später');
      expect(absenz.simpleTitle, 'Probe MVU');
      expect(absenz.location, 'Zentrum Urdorf');
      expect(absenz.from, DateTime(2026, 11, 18, 19, 30));
      expect(absenz.to, DateTime(2026, 11, 18, 22));
      expect(absenz.infoOnly, isFalse);
    });

    test('maps the uppercase backend status to AbsenzState', () {
      expect(Absenz.fromJson(absenzJson(status: 'POSITIVE')).status, AbsenzState.positive);
      expect(Absenz.fromJson(absenzJson(status: 'NEGATIVE')).status, AbsenzState.negative);
      expect(Absenz.fromJson(absenzJson(status: 'INACTIVE')).status, AbsenzState.inactive);
    });

    test('falls back to unknown for unrecognized status', () {
      expect(Absenz.fromJson(absenzJson(status: 'SOMETHING_NEW')).status, AbsenzState.unknown);
      expect(Absenz.fromJson(absenzJson(status: 'positive')).status, AbsenzState.unknown);
    });

    test('accepts a missing remark', () {
      expect(Absenz.fromJson(absenzJson(remark: null)).remark, isNull);
    });
  });

  group('Absenz.toJson', () {
    test('produces the payload the backend expects on update', () {
      final absenz = Absenz.fromJson(absenzJson())
        ..status = AbsenzState.negative
        ..remark = 'krank';

      expect(absenz.toJson(), <String, dynamic>{
        'loginId': 7,
        'eventId': 42,
        'title': 'Probe',
        'subtitle': 'Mittwoch, 19:30',
        'interna': 'Register Holz',
        'status': 'NEGATIVE',
        'remark': 'krank',
        'infoOnly': false,
      });
    });

    test('status survives a round trip', () {
      for (final state in [AbsenzState.positive, AbsenzState.negative, AbsenzState.inactive]) {
        final absenz = Absenz.fromJson(absenzJson())..status = state;
        final roundTripped = Absenz.fromJson({...absenzJson(), ...json.decode(jsonEncode(absenz))});
        expect(roundTripped.status, state);
      }
    });
  });
}
