import 'package:flutter/material.dart';
import 'package:flutter_app/model/db/db_proxy.dart';
import 'package:flutter_app/model/service/task_data_service.dart';

class AuthService extends ChangeNotifier {
  final DBProxy _dbProxy;

  AuthService(this._dbProxy);

  Future<TaskDataService> login(String email, String password) async {
    final token = await _dbProxy.login(email, password);
    return TaskDataService(token, _dbProxy);
  }

  Future<TaskDataService> register(String email, String password) async {
    final token = await _dbProxy.register(email, password);
    return TaskDataService(token, _dbProxy);
  }
}
