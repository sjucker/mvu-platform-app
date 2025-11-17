import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:mvu_platform/dto/konzert.dart';
import 'package:mvu_platform/service/base_service.dart';

Future<List<Konzert>> getKonzerte() async {
  final http.Response response = await http.get(Uri.parse('$baseUrl/api/secured/konzert'), headers: await getHeaders());

  if (response.statusCode == HttpStatus.ok) {
    return json.decode(utf8.decode(response.bodyBytes)).map<Konzert>((dynamic data) => Konzert.fromJson(data)).toList();
  } else {
    return Future.error('failed, status code: ${response.statusCode}');
  }
}

Future<Konzert> getKonzertById(int id) async {
  final http.Response response = await http.get(Uri.parse('$baseUrl/api/secured/konzert/$id'), headers: await getHeaders());

  if (response.statusCode == HttpStatus.ok) {
    return Konzert.fromJson(json.decode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>);
  } else {
    return Future.error('failed, status code: ${response.statusCode}');
  }
}
