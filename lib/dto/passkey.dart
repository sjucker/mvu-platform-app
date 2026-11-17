/// Options for a passkey registration or login, as returned by the backend.
class PasskeyOptions {
  PasskeyOptions(this.requestId, this.publicKey);

  factory PasskeyOptions.fromJson(Map<String, dynamic> json) {
    return PasskeyOptions(json['requestId'], (json['options'] as Map<String, dynamic>)['publicKey']);
  }

  /// Must be sent back when finishing the registration/login.
  final String requestId;

  /// WebAuthn `PublicKeyCredentialCreationOptions` or `PublicKeyCredentialRequestOptions` as JSON.
  final Map<String, dynamic> publicKey;
}

class Passkey {
  Passkey(this.id, this.name, this.createdAt, this.lastUsedAt);

  factory Passkey.fromJson(Map<String, dynamic> json) {
    return Passkey(json['id'], json['name'], DateTime.parse(json['createdAt']), json['lastUsedAt'] != null ? DateTime.parse(json['lastUsedAt']) : null);
  }

  final int id;
  final String name;
  final DateTime createdAt;
  final DateTime? lastUsedAt;
}

class PasskeyLogin {
  PasskeyLogin(this.customToken);

  factory PasskeyLogin.fromJson(Map<String, dynamic> json) {
    return PasskeyLogin(json['customToken']);
  }

  /// Firebase custom token to sign in with.
  final String customToken;
}
