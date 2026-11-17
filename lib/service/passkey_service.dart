import 'dart:convert';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:mvu_platform/dto/passkey.dart';
import 'package:mvu_platform/service/base_service.dart';
import 'package:passkeys/authenticator.dart';
import 'package:passkeys/types.dart';

final PasskeyAuthenticator _authenticator = PasskeyAuthenticator();

const Map<String, String> _jsonHeaders = <String, String>{HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8'};

/// Signs in with a passkey stored on the device. Throws [PasskeyAuthCancelledException] if the user dismisses the dialog.
Future<void> loginWithPasskey() async {
  final startResponse = await http.post(Uri.parse('$baseUrl/api/passkey/login/start'), headers: _jsonHeaders);
  if (startResponse.statusCode != HttpStatus.ok) {
    throw Exception('failed to start passkey login, status code: ${startResponse.statusCode}');
  }
  final options = PasskeyOptions.fromJson(json.decode(utf8.decode(startResponse.bodyBytes)));

  final credential = await _authenticator.authenticate(AuthenticateRequestType.fromJson(options.publicKey, preferImmediatelyAvailableCredentials: false));

  final finishResponse = await http.post(
    Uri.parse('$baseUrl/api/passkey/login/finish/${options.requestId}'),
    headers: _jsonHeaders,
    body: credential.toJsonString(),
  );
  if (finishResponse.statusCode != HttpStatus.ok) {
    throw Exception('failed to finish passkey login, status code: ${finishResponse.statusCode}');
  }
  final login = PasskeyLogin.fromJson(json.decode(utf8.decode(finishResponse.bodyBytes)));

  await FirebaseAuth.instance.signInWithCustomToken(login.customToken);
}

/// Creates a passkey for the signed-in user on the device and registers it with the backend.
Future<void> registerPasskey() async {
  final startResponse = await http.post(Uri.parse('$baseUrl/api/secured/passkey/register/start'), headers: await getHeaders());
  if (startResponse.statusCode != HttpStatus.ok) {
    throw Exception('failed to start passkey registration, status code: ${startResponse.statusCode}');
  }
  final options = PasskeyOptions.fromJson(json.decode(utf8.decode(startResponse.bodyBytes)));

  final credential = await _authenticator.register(RegisterRequestType.fromJson(options.publicKey));

  final name = Platform.isIOS ? 'iPhone / iPad' : 'Android';
  final finishResponse = await http.post(
    Uri.parse('$baseUrl/api/secured/passkey/register/finish/${options.requestId}').replace(queryParameters: {'name': name}),
    headers: await getHeaders(),
    body: credential.toJsonString(),
  );
  if (finishResponse.statusCode != HttpStatus.ok) {
    throw Exception('failed to finish passkey registration, status code: ${finishResponse.statusCode}');
  }
}

Future<List<Passkey>> getPasskeys() async {
  final http.Response response = await http.get(Uri.parse('$baseUrl/api/secured/passkey'), headers: await getHeaders());

  if (response.statusCode == HttpStatus.ok) {
    return json.decode(utf8.decode(response.bodyBytes)).map<Passkey>((dynamic data) => Passkey.fromJson(data)).toList();
  } else {
    return Future.error('failed, status code: ${response.statusCode}');
  }
}

Future<void> deletePasskey(int id) async {
  final http.Response response = await http.delete(Uri.parse('$baseUrl/api/secured/passkey/$id'), headers: await getHeaders());

  if (response.statusCode != HttpStatus.ok) {
    throw Exception('failed to delete passkey, status code: ${response.statusCode}');
  }
}
