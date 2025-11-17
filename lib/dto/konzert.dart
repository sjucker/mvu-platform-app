class Konzert {
  factory Konzert.fromJson(Map<String, dynamic> json) {
    return Konzert(
      json['id'],
      json['name'],
      DateTime.parse('${json['datum']} ${json['zeit']}'),
      json['location'],
      json['description'],
      json['tenu'],
      (json['entries'] as List).map((e) => KonzertEntry.fromJson(e)).toList(),
    );
  }

  final int id;
  final String name;
  final DateTime dateTime;
  final String? location;
  final String? description;
  final String? tenu;
  final List<KonzertEntry> entries;

  Konzert(this.id, this.name, this.dateTime, this.location, this.description, this.tenu, this.entries);
}

class KonzertEntry {
  final int index;
  final double? marschbuchNumber;
  final String? placeholder;
  final int? kompositionId;
  final String? kompositionTitel;
  final String? kompositionKomponist;
  final String? kompositionArrangeur;
  final String? kompositionAudioSample;
  final bool zugabe;

  factory KonzertEntry.fromJson(Map<String, dynamic> json) {
    return KonzertEntry(
      json['index'],
      json['marschbuchNumber'],
      json['placeholder'],
      json['kompositionId'],
      json['kompositionTitel'],
      json['kompositionKomponist'],
      json['kompositionArrangeur'],
      json['kompositionAudioSample'],
      json['zugabe'],
    );
  }

  KonzertEntry(
    this.index,
    this.marschbuchNumber,
    this.placeholder,
    this.kompositionId,
    this.kompositionTitel,
    this.kompositionKomponist,
    this.kompositionArrangeur,
    this.kompositionAudioSample,
    this.zugabe,
  );
}
