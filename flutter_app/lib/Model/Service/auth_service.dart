import 'package:flutter/material.dart';
import 'package:flutter_app/Model/DB/db_proxy.dart';

class AuthService extends ChangeNotifier {
  final DBProxy _dbProxy;

  AuthService(this._dbProxy);

  Future<String> login(String email, String password) {
    return _dbProxy.login(email, password);
  }
}
