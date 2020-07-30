import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Api {
  final String _url = 'http://192.168.0.13:3000/api';

  var token;

  _getToken() async {
    final storage = FlutterSecureStorage();
    token = jsonDecode(await storage.read(key: 'access_token'));
  }

  _setHeaders() => {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token'
      };

  authData(data, apiUrl) async {
    var fullUrl = _url + apiUrl;
    return await http.post(fullUrl,
        body: jsonEncode(data), headers: _setHeaders());
  }

  getData(apiUrl) async {
    var fullUrl = _url + apiUrl;
    await _getToken();
    return await http.get(
      fullUrl,
      headers: _setHeaders(),
    );
  }

}
