import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:mvu_platform/dto/absenz.dart';
import 'package:mvu_platform/service/base_service.dart';

Future<List<Absenz>> getAbsenzen() async {
  final http.Response response = await http.get(Uri.parse('$baseUrl/api/secured/event'), headers: await getHeaders());

  if (response.statusCode == HttpStatus.ok) {
    return json.decode(utf8.decode(response.bodyBytes)).map<Absenz>((dynamic data) => Absenz.fromJson(data)).toList();
  } else {
    throw Exception('failed to load absenzen, status code: ${response.statusCode}');
  }
}

Future<void> updateAbsenz(Absenz absenz) async {
  final response = await http.put(Uri.parse('$baseUrl/api/secured/event/${absenz.eventId}'), headers: await getHeaders(), body: jsonEncode(absenz));

  if (response.statusCode == HttpStatus.ok) {
    return;
  } else {
    throw Exception('failed to update absenz, status code: ${response.statusCode}');
  }
}
