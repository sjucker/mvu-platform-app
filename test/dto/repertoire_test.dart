import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mvu_platform/dto/repertoire.dart';

RepertoireEntry entry({String? komponist, String? arrangeur}) => RepertoireEntry(1, 'Titel', komponist, arrangeur, null, null);

void main() {
  group('Repertoire.fromJson', () {
    test('parses type, metadata and entries', () {
      final repertoire = Repertoire.fromJson(
        json.decode('''
{
  "type": "MARSCHBUCH",
  "createdAt": "2026-03-01T10:15:00",
  "createdBy": "Notenarchiv",
  "details": "Ausgabe 2026",
  "entries": [
    {
      "kompositionId": 5,
      "kompositionTitel": "Alte Kameraden",
      "kompositionKomponist": "Carl Teike",
      "kompositionArrangeur": null,
      "kompositionAudioSample": "https://example.com/sample.mp3",
      "number": 101.0
    }
  ]
}
'''),
      );

      expect(repertoire.type, RepertoireType.marschbuch);
      expect(repertoire.createdAt, DateTime(2026, 3, 1, 10, 15));
      expect(repertoire.createdBy, 'Notenarchiv');
      expect(repertoire.details, 'Ausgabe 2026');
      expect(repertoire.entries, hasLength(1));
      expect(repertoire.entries.single.kompositionTitel, 'Alte Kameraden');
      expect(repertoire.entries.single.kompositionAudioSample, 'https://example.com/sample.mp3');
      expect(repertoire.entries.single.number, 101.0);
    });
  });

  group('RepertoireEntry.fromJson', () {
    test('accepts number as a whole number', () {
      final entry = RepertoireEntry.fromJson(json.decode('{"kompositionId": 5, "kompositionTitel": "Alte Kameraden", "number": 101}'));
      expect(entry.number, 101.0);
    });
  });

  group('RepertoireType', () {
    test('uppercase name matches the API path segment', () {
      expect(RepertoireType.konzertmappe.name.toUpperCase(), 'KONZERTMAPPE');
      expect(RepertoireType.marschbuch.name.toUpperCase(), 'MARSCHBUCH');
    });

    test('has a display description', () {
      expect(RepertoireType.konzertmappe.description, 'Konzertmappe');
      expect(RepertoireType.marschbuch.description, 'Marschbuch');
    });
  });

  group('RepertoireEntry.subtitle', () {
    test('shows composer and arranger', () {
      expect(entry(komponist: 'Ravel', arrangeur: 'Smith').subtitle, 'Ravel (arr. Smith)');
    });

    test('shows composer only', () {
      expect(entry(komponist: 'Ravel').subtitle, 'Ravel');
    });

    test('shows arranger only', () {
      expect(entry(arrangeur: 'Smith').subtitle, 'arr. Smith');
    });

    test('is empty when neither is set', () {
      expect(entry().subtitle, '');
    });
  });
}
