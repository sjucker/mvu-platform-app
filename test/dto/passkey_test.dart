import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mvu_platform/dto/passkey.dart';

void main() {
  group('PasskeyOptions.fromJson', () {
    test('unwraps the publicKey of registration options', () {
      final options = PasskeyOptions.fromJson(
        json.decode('''
{
  "requestId": "7c0c5f8e-2f4a-4a8e-9a43-0d8b7f6b2d11",
  "options": {
    "publicKey": {
      "rp": {"name": "Musikverein Harmonie Urdorf", "id": "platform.mvurdorf.ch"},
      "user": {"name": "test@mvurdorf.ch", "displayName": "Test", "id": "q83vEjRWeJA"},
      "challenge": "Zm9vYmFy",
      "pubKeyCredParams": [{"alg": -7, "type": "public-key"}, {"alg": -257, "type": "public-key"}],
      "excludeCredentials": [],
      "authenticatorSelection": {"requireResidentKey": true, "residentKey": "required", "userVerification": "required"},
      "attestation": "none",
      "extensions": {"credProps": true}
    }
  }
}'''),
      );

      expect(options.requestId, '7c0c5f8e-2f4a-4a8e-9a43-0d8b7f6b2d11');
      expect(options.publicKey['challenge'], 'Zm9vYmFy');
      expect(options.publicKey['rp']['id'], 'platform.mvurdorf.ch');
    });

    test('unwraps the publicKey of login options', () {
      final options = PasskeyOptions.fromJson(
        json.decode('''
{
  "requestId": "0e7a4c3d-91b2-4f7e-8d1a-5b6c7d8e9f00",
  "options": {
    "publicKey": {
      "challenge": "YmFyYmF6",
      "rpId": "platform.mvurdorf.ch",
      "allowCredentials": [],
      "userVerification": "required",
      "extensions": {}
    }
  }
}'''),
      );

      expect(options.requestId, '0e7a4c3d-91b2-4f7e-8d1a-5b6c7d8e9f00');
      expect(options.publicKey['rpId'], 'platform.mvurdorf.ch');
    });
  });

  group('Passkey.fromJson', () {
    test('parses a used passkey', () {
      final passkey = Passkey.fromJson(
        json.decode('{"id": 4, "name": "iPhone / iPad", "createdAt": "2026-11-17T15:34:18.528413", "lastUsedAt": "2026-11-18T07:02:11.004"}'),
      );

      expect(passkey.id, 4);
      expect(passkey.name, 'iPhone / iPad');
      expect(passkey.createdAt, DateTime(2026, 11, 17, 15, 34, 18, 528, 413));
      expect(passkey.lastUsedAt, DateTime(2026, 11, 18, 7, 2, 11, 4));
    });

    test('parses an unused passkey', () {
      final passkey = Passkey.fromJson(json.decode('{"id": 5, "name": "Android", "createdAt": "2026-11-17T15:34:18", "lastUsedAt": null}'));

      expect(passkey.lastUsedAt, isNull);
    });
  });

  test('PasskeyLogin.fromJson', () {
    expect(PasskeyLogin.fromJson(json.decode('{"customToken": "eyJhbGciOiJSUzI1NiJ9.e30.c2ln"}')).customToken, 'eyJhbGciOiJSUzI1NiJ9.e30.c2ln');
  });
}
