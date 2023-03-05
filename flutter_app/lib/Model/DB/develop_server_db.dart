import 'package:flutter_app/model/db/db_proxy.dart';
import 'package:flutter_app/model/db/laravel_connect.dart';
import 'package:flutter_app/model/types/Task.dart';

class DevelopServerDB extends DBProxy with LaravelConnect {
  static const _host = 'localhost';
  static const _loginPath = 'api/login';
  static const _registerPath = 'api/register';
  static const _indexPath = 'api/index';

  @override
  Future<String> login(String email, String password) async {
    final reqObj = {
      "email": email,
      "password": password,
    };
    final resObj =
        await post(_host, _loginPath, reqObj, null) as Map<String, dynamic>;
    return resObj["token"] as String;
  }

  @override
  Future<String> register(String email, String password) async {
    final reqObj = {
      "email": email,
      "password": password,
    };
    final resObj =
        await post(_host, _registerPath, reqObj, null) as Map<String, dynamic>;
    return resObj["token"] as String;
  }

  @override
  Future<List<Task>> getAllTasks(String token) async {
    final resObj = await get(_host, _indexPath, token) as List;
    final tasks = resObj.map((e) => Task.fromJson(e)).toList();
    return tasks;
  }
}
