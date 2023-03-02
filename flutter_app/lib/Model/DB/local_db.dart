import 'dart:convert';
import 'dart:math';
import 'package:flutter_app/model/db/db_proxy.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class LocalDB extends DBProxy {
  LocalDB();

  @override
  Future<String> login(String email, String password) async {
    final fileStr = await _getFile('local_db/users.json');
    final fileObj = jsonDecode(fileStr) as List;
    for (Map userData in fileObj) {
      if (userData['email'] == email) {
        if (userData['password'] == password) {
          final String token = await _addToken(userData['id']);
          return token;
        } else {
          throw const FormatException('パスワードが異なります');
        }
      }
    }
    throw const FormatException('メールアドレスが登録されていません');
  }

  ///ディレクトリからのパスで指定したファイルの内容を読み込む
  Future<String> _getFile(String filepath) async {
    final Directory directory = await getApplicationDocumentsDirectory();
    final File file = File('${directory.path}/$filepath');
    return await file.readAsString();
  }

  ///指定IDのユーザーのトークンを作成しtokens.jsonに追加、そのトークンを返す
  Future<String> _addToken(int id) async {
    final String token = _createRandomToken();
    final Directory directory = await getApplicationDocumentsDirectory();
    final File file = File('${directory.path}/local_db/tokens.json');
    final String file_str = file.readAsStringSync();
    final Map tokenMap = jsonDecode(file_str) as Map<String, dynamic>;
    tokenMap[token] = id;
    file.writeAsStringSync(jsonEncode(tokenMap));
    return token;
  }

  String _createRandomToken() {
    const charset = '0123456789abcdefghijklmnopqrstuvwxyz';
    final Random random = Random.secure();
    return List.generate(32, (_) => charset[random.nextInt(20)]).join();
  }
}
