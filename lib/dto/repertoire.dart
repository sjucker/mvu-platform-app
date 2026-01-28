enum RepertoireType { konzertmappe, marschbuch }

extension RepertoireTypeDescription on RepertoireType {
  String get description {
    switch (this) {
      case RepertoireType.konzertmappe:
        return "Konzertmappe";
      case RepertoireType.marschbuch:
        return "Marschbuch";
    }
  }
}

class Repertoire {
  Repertoire(this.type, this.createdAt, this.createdBy, this.details, this.entries);

  factory Repertoire.fromJson(Map<String, dynamic> json) {
    return Repertoire(
      RepertoireType.values.firstWhere((RepertoireType e) => e.name.toUpperCase() == json['type']),
      DateTime.parse(json['createdAt']),
      json['createdBy'],
      json['details'],
      (json['entries'] as List).map((e) => RepertoireEntry.fromJson(e)).toList(),
    );
  }

  final RepertoireType type;
  final DateTime createdAt;
  final String createdBy;
  final String details;
  final List<RepertoireEntry> entries;
}

class RepertoireEntry {
  RepertoireEntry(this.kompositionId, this.kompositionTitel, this.kompositionKomponist, this.kompositionArrangeur, this.kompositionAudioSample, this.number);

  factory RepertoireEntry.fromJson(Map<String, dynamic> json) {
    return RepertoireEntry(
      json['kompositionId'],
      json['kompositionTitel'],
      json['kompositionKomponist'],
      json['kompositionArrangeur'],
      json['kompositionAudioSample'],
      json['number'],
    );
  }

  final int kompositionId;
  final String kompositionTitel;
  final String? kompositionKomponist;
  final String? kompositionArrangeur;
  final String? kompositionAudioSample;
  final double? number;

  String get subtitle {
    if (kompositionKomponist != null && kompositionArrangeur != null) {
      return "$kompositionKomponist (arr. $kompositionArrangeur)";
    } else if (kompositionKomponist != null) {
      return kompositionKomponist!;
    } else if (kompositionArrangeur != null) {
      return "arr. $kompositionArrangeur";
    } else {
      return "";
    }
  }
}
