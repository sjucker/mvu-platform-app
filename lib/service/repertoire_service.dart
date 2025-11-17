import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:mvu_platform/dto/repertoire.dart';
import 'package:mvu_platform/service/base_service.dart';

Future<Repertoire> getRepertoire(RepertoireType repertoireType) async {
  final http.Response response = await http.get(Uri.parse('$baseUrl/api/secured/repertoire/${repertoireType.name.toUpperCase()}'), headers: await getHeaders());

  if (response.statusCode == HttpStatus.ok) {
    return Repertoire.fromJson(json.decode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>);
  } else {
    return Future.error('failed, status code: ${response.statusCode}');
  }
}
