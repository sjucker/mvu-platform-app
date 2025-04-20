import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:mvu_platform/service/base_service.dart';

Future<String> ping() async {
  final http.Response response = await http.get(
    Uri.parse('$baseUrl/api/secured/repertoire'),
    headers: await getHeaders(),
  );

  if (response.statusCode == HttpStatus.ok) {
    return response.body;
  } else {
    return Future.error('failed, status code: ${response.statusCode}');
  }
}
