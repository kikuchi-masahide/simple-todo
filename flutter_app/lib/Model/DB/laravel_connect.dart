import 'dart:convert';
import 'dart:io';

mixin LaravelConnect {
  Future<Object> post(String host, String path, Object obj) async {
    var http = HttpClient();
    try {
      HttpClientRequest request = await http.post(host, 80, path);
      final reqBody = jsonEncode(obj);
      request.headers.contentType = ContentType('application', 'json');
      request.write(reqBody);
      HttpClientResponse response = await request.close();
      if (response.statusCode != 200 && response.statusCode != 400) {
        throw const FormatException('ネットワークエラー');
      }
      final resBodyStr = await response.transform(utf8.decoder).join();
      final Object resBody = jsonDecode(resBodyStr);
      if (response.statusCode == 400) {
        throw FormatException('ネットワークエラー:${(resBody as Map)["message"]}');
      }
      return resBody;
    } on FormatException catch (_) {
      rethrow;
    } on Exception catch (_) {
      throw const FormatException('ネットワークエラー');
    }
  }
}
