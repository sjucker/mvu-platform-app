class TokenUpdate {
  TokenUpdate(this.token);

  factory TokenUpdate.fromJson(Map<String, dynamic> json) {
    return TokenUpdate(json['token']);
  }

  final String token;

  Map<String, dynamic> toJson() => <String, dynamic>{'token': token};
}
