import 'dart:convert';
import 'package:http/http.dart' as http;

mixin LaravelConnect {
  Future<dynamic> post(
      String host, String path, Object obj, String? token) async {
    try {
      var uri = Uri.http(host, path);
      Map<String, String> header = {
        'Content-Type': 'application/json',
      };
      if (token != null) {
        header["Authorization"] = 'Bearer $token';
      }
      var response =
          await http.post(uri, headers: header, body: jsonEncode(obj));
      var status = response.statusCode;
      var body = jsonDecode(utf8.decode(response.bodyBytes));
      if (status != 200) {
        if (status == 400) {
          throw FormatException(body["message"]);
        } else {
          throw FormatException('ネットワークエラー ステータスコード$status');
        }
      }
      return body;
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> get(String host, String path, String? token) async {
    try {
      var uri = Uri.http(host, path);
      Map<String, String> header = {};
      if (token != null) {
        header["Authorization"] = 'Bearer $token';
      }
      var response = await http.get(uri, headers: header);
      var status = response.statusCode;
      var body = jsonDecode(utf8.decode(response.bodyBytes));
      if (status != 200) {
        if (status == 400) {
          throw FormatException(body["message"]);
        } else {
          throw FormatException('ネットワークエラー ステータスコード$status');
        }
      }
      return body;
    } catch (e) {
      rethrow;
    }
  }
}
