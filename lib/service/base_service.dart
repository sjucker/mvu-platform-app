import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';

const String baseUrl = 'https://platform.mvurdorf.ch';

Future<IdTokenResult> getFirebaseToken() async =>
    FirebaseAuth.instance.currentUser!.getIdTokenResult();

Future<Map<String, String>> getHeaders() async {
  return getFirebaseToken().then(
    (token) => <String, String>{
      HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8',
      HttpHeaders.authorizationHeader: 'Bearer ${token.token}',
    },
  );
}
