import 'package:flutter_app/model/db/db_proxy.dart';
import 'package:flutter_app/model/db/laravel_connect.dart';
import 'package:flutter_app/model/types/task.dart';

class DevelopServerDB extends DBProxy with LaravelConnect {
  static const _host = 'localhost';
  static const _loginPath = 'api/login';
  static const _registerPath = 'api/register';
  static const _indexPath = 'api/index';
  static const _uploadPath = 'api/update';
  static const _logoutPath = 'api/logout';

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

  @override
  Future<void> upload(String token, List<Task> tasks) async {
    final reqObj = {
      'tasks': tasks
          .where((task) => !task.done)
          .map((task) => task.toJson())
          .toList(),
    };
    await post(_host, _uploadPath, reqObj, token);
  }

  @override
  Future<void> logout(String token) async {
    await post(_host, _logoutPath, {}, token);
  }
}
