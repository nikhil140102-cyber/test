import 'dart:convert';

import 'package:http/http.dart' as http;

/// Calls REST APIs set up in the builder (App → APIs).
class Api {
  /// GETs [url] and returns the list found at [listPath] (e.g. "data.items").
  static Future<List<Map<String, dynamic>>> getList(String url, String listPath, {int limit = 50}) async {
    final res = await http.get(Uri.parse(url));
    if (res.statusCode >= 400) throw Exception('The server answered ${res.statusCode}.');
    Object? data = jsonDecode(res.body);
    for (final part in listPath.split('.').where((p) => p.isNotEmpty)) {
      data = data is Map ? data[part] : null;
    }
    if (data is! List) return [];
    return [
      for (final row in data.take(limit)) row is Map ? Map<String, dynamic>.from(row) : {'value': row},
    ];
  }

  /// POSTs [body] as JSON to [url].
  static Future<void> post(String url, Map<String, dynamic> body) async {
    final res = await http.post(
      Uri.parse(url),
      headers: {'content-type': 'application/json'},
      body: jsonEncode(body),
    );
    if (res.statusCode >= 400) throw Exception('The server answered ${res.statusCode}.');
  }
}
