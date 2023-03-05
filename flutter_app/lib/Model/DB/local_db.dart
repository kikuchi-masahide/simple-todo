import 'dart:math';
import 'package:flutter_app/model/types/token.dart';
import 'package:flutter_app/model/types/user.dart';
import 'package:flutter_app/model/db/db_proxy.dart';
import 'package:flutter_app/model/db/local_file_io.dart';

class LocalDB extends DBProxy with LocalFileIO {
  //static const _tokenLifespan = const Duration(minutes: 1);
  static const _tokenLifespan = const Duration(days: 1);

  LocalDB();

  @override
  Future<String> login(String email, String password) async {
    var users = await _readUsersFile();
    for (var user in users) {
      if (user.email == email) {
        if (user.password == password) {
          final String token = await _addToken(user.id);
          return token;
        } else {
          throw const FormatException('パスワードが異なります');
        }
      }
    }
    throw const FormatException('メールアドレスが登録されていません');
  }

  @override
  Future<String> register(String email, String password) async {
    var users = await _readUsersFile();
    int unusedID = 0;
    for (User user in users) {
      if (user.email == email) {
        throw const FormatException('登録ずみのメールアドレスです');
      }
      if (unusedID <= user.id) {
        unusedID = user.id + 1;
      }
    }
    User newuser = User(unusedID, email, password);
    users.add(newuser);
    await writeFile('local_db/users.json', users);
    return await _addToken(unusedID);
  }

  Future<List<User>> _readUsersFile() async {
    final fileObj = await readFile('local_db/users.json') as List;
    return fileObj.map<User>((json) => User.fromJson(json)).toList();
  }

  Future<Map<String, Token>> _readTokensFile() async {
    final tokenMap =
        await readFile('local_db/tokens.json') as Map<String, dynamic>;
    Map<String, Token> tokens = {};
    tokenMap.forEach((key, value) {
      tokens[key] = Token.fromJson(value);
    });
    return tokens;
  }

  ///指定IDのユーザーのトークンを作成しtokens.jsonに追加、そのトークンを返す
  Future<String> _addToken(int id) async {
    final String token = _createRandomToken();
    final DateTime limit = DateTime.now().add(_tokenLifespan);
    //Map<String,Token>
    final tokens = await _readTokensFile();
    tokens[token] = Token(token, id, limit);
    await writeFile('local_db/tokens.json', tokens);
    return token;
  }

  String _createRandomToken() {
    const charset = '0123456789abcdefghijklmnopqrstuvwxyz';
    final Random random = Random.secure();
    return List.generate(32, (_) => charset[random.nextInt(20)]).join();
  }
}
