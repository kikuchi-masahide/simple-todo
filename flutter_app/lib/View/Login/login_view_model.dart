import 'package:flutter/material.dart';
import 'package:flutter_app/Model/Service/auth_service.dart';

class LoginViewModel extends ChangeNotifier {
  final AuthService _authService;

  LoginViewModel(this._authService);

  Future<void> login(
      BuildContext context, String email, String password) async {
    final String token = await _authService.login(email, password);
    //tokenを用いたページ遷移処理
    return;
  }
}
