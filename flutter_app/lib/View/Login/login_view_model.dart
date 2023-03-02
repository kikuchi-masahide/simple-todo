import 'package:flutter/material.dart';
import 'package:flutter_app/model/service/auth_service.dart';

class LoginViewModel extends ChangeNotifier {
  final AuthService _authService;

  ///ログイン処理中か否か
  late bool _loginProcessing;

  ///画面上部に表示するメッセージ
  late String? _message;

  LoginViewModel(this._authService) {
    _loginProcessing = false;
    _message = null;
  }

  Future<void> login(
      BuildContext context, String email, String password) async {
    _loginProcessing = true;
    notifyListeners();
    try {
      await new Future.delayed(Duration(seconds: 3));
      final String token = await _authService.login(email, password);
      _message = 'ログインに成功しました';
    } on FormatException catch (e) {
      _message = '''ログインに失敗しました
エラー:${e.message}''';
    } finally {
      _loginProcessing = false;
      notifyListeners();
    }
    //tokenを用いたページ遷移処理
    return;
  }

  bool get loginProcessing => _loginProcessing;

  String? get message => _message;
}
