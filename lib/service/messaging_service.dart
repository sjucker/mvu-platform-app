import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:mvu_platform/dto/messaging.dart';
import 'package:mvu_platform/service/base_service.dart';

Future<void> updateFcmToken(String fcmToken) async {
  final response = await http.put(Uri.parse('$baseUrl/api/secured/messaging'), headers: await getHeaders(), body: jsonEncode(TokenUpdate(fcmToken)));

  if (response.statusCode == HttpStatus.ok) {
    return;
  } else {
    throw Exception('failed to update fcmToken, status code: ${response.statusCode}');
  }
}
