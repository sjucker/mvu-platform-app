enum AbsenzState { positive, negative, inactive, unknown }

class Absenz {
  Absenz(
    this.loginId,
    this.eventId,
    this.title,
    this.subtitle,
    this.interna,
    this.status,
    this.remark,
    this.simpleTitle,
    this.location,
    this.from,
    this.to,
    this.infoOnly,
  );

  factory Absenz.fromJson(Map<String, dynamic> json) {
    return Absenz(
      json['loginId'],
      json['eventId'],
      json['title'],
      json['subtitle'],
      json['interna'],
      AbsenzState.values.firstWhere((AbsenzState e) => e.name.toUpperCase() == json['status'], orElse: () => AbsenzState.unknown),
      json['remark'],
      json['simpleTitle'],
      json['location'],
      DateTime.parse(json['from']),
      DateTime.parse(json['to']),
      json['infoOnly'],
    );
  }

  final int loginId;
  final int eventId;
  final String title;
  final String subtitle;
  final String interna;
  AbsenzState status;
  String? remark;
  final String simpleTitle;
  final String location;
  final DateTime from;
  final DateTime to;
  final bool infoOnly;

  Map<String, dynamic> toJson() => <String, dynamic>{
    'loginId': loginId,
    'eventId': eventId,
    'title': title,
    'subtitle': subtitle,
    'interna': interna,
    'status': status.name.toUpperCase(),
    'remark': remark,
    'infoOnly': infoOnly,
  };

  @override
  String toString() {
    return 'title=$title, subtitle=$subtitle, status=$status, remark=$remark';
  }
}
