import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:mvu_platform/dto/messaging.dart';
import 'package:mvu_platform/service/base_service.dart';

/// Sends the Firebase Installation ID (FID) used for direct-send messaging to the backend.
Future<void> updateFid(String fid) async {
  final response = await http.put(Uri.parse('$baseUrl/api/secured/messaging'), headers: await getHeaders(), body: jsonEncode(TokenUpdate(fid)));

  if (response.statusCode == HttpStatus.ok) {
    return;
  } else {
    throw Exception('failed to update FID, status code: ${response.statusCode}');
  }
}
