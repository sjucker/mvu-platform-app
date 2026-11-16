import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mvu_platform/dto/konzert.dart';

KonzertEntry entry({String? titel, String? placeholder}) => KonzertEntry(1, null, placeholder, null, titel, null, null, null, false, null);

void main() {
  group('Konzert.fromJson', () {
    test('combines datum and zeit into dateTime and parses entries', () {
      final konzert = Konzert.fromJson(
        json.decode('''
{
  "id": 3,
  "name": "Jahreskonzert",
  "datum": "2026-12-05",
  "zeit": "19:30:00",
  "location": "Mehrzweckhalle",
  "description": null,
  "tenu": "Uniform",
  "entries": [
    {
      "index": 1,
      "marschbuchNumber": 12.0,
      "placeholder": null,
      "kompositionId": 99,
      "kompositionTitel": "Bolero",
      "kompositionKomponist": "Maurice Ravel",
      "kompositionArrangeur": null,
      "kompositionAudioSample": null,
      "zugabe": false,
      "additionalInfo": null
    },
    {
      "index": 2,
      "marschbuchNumber": null,
      "placeholder": "Pause",
      "kompositionId": null,
      "kompositionTitel": null,
      "kompositionKomponist": null,
      "kompositionArrangeur": null,
      "kompositionAudioSample": null,
      "zugabe": true,
      "additionalInfo": "20 Minuten"
    }
  ]
}
'''),
      );

      expect(konzert.id, 3);
      expect(konzert.name, 'Jahreskonzert');
      expect(konzert.dateTime, DateTime(2026, 12, 5, 19, 30));
      expect(konzert.location, 'Mehrzweckhalle');
      expect(konzert.description, isNull);
      expect(konzert.tenu, 'Uniform');

      expect(konzert.entries, hasLength(2));
      expect(konzert.entries[0].marschbuchNumber, 12.0);
      expect(konzert.entries[0].kompositionId, 99);
      expect(konzert.entries[0].title, 'Bolero');
      expect(konzert.entries[1].zugabe, isTrue);
      expect(konzert.entries[1].additionalInfo, '20 Minuten');
      expect(konzert.entries[1].title, '--- Pause ---');
    });
  });

  group('KonzertEntry.fromJson', () {
    test('accepts marschbuchNumber as a whole number', () {
      final entry = KonzertEntry.fromJson(json.decode('{"index": 1, "marschbuchNumber": 12, "zugabe": false}'));
      expect(entry.marschbuchNumber, 12.0);
    });
  });

  group('KonzertEntry.title', () {
    test('prefers the composition title', () {
      expect(entry(titel: 'Bolero', placeholder: 'Pause').title, 'Bolero');
    });

    test('formats a placeholder when there is no composition', () {
      expect(entry(placeholder: 'Pause').title, '--- Pause ---');
    });

    test('is empty when neither is set', () {
      expect(entry().title, '');
    });
  });
}
