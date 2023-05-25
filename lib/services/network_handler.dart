import 'dart:convert';

import 'package:http/http.dart' as http;

class NetworkHandler {
  final String url = "pokeapi.co";
  final String path;
  NetworkHandler({required this.path});

  Future<Map<String, dynamic>> getRequest({Map<String, String>? params}) async {
    http.Response response = await http.get(Uri.https(url, path, params));
    if (response.statusCode == 200) {
      return jsonDecode(response.body) as Map<String, dynamic>;
    }
    throw 'Código: ${response.statusCode}';
  }
}
