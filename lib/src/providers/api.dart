import 'dart:convert';
import 'package:cogniplus_mobile/appConfig.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Api {
  final String _url = AppConfig.apihost;

  var token;

  _getToken() async {
    final storage = FlutterSecureStorage();
    token = await storage.read(key: 'access_token');
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

  getDataFromApi({url}) async {
    var fullUrl = _url + url;
    await _getToken();
    return await http.get(
      fullUrl,
      headers: _setHeaders(),
    );
  }

  delDataFromApi({url}) async {
    var fullUrl = _url + url;
    await _getToken();
    return await http.delete(
      fullUrl,
      headers: _setHeaders(),
    );
  }

  setPostDataFromApi({String url, data}) async {
    String fullUrl = _url + url;
    data = jsonEncode(data);
    await _getToken();
    return await http.post(fullUrl, headers: _setHeaders(), body: data);
  }
  
  setUpdateDataFromApi({String url, data}) async {
    String fullUrl = _url + url;
    data = jsonEncode(data);
    await _getToken();
    return await http.patch(fullUrl, headers: _setHeaders(), body: data);
  }
}
