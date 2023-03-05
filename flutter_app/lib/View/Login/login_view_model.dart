import 'package:flutter/material.dart';
import 'package:flutter_app/model/service/auth_service.dart';
import 'package:flutter_app/model/service/task_data_service.dart';
import 'package:flutter_app/view/register/register_view_provider.dart';

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

  Future<TaskDataService?> login(
      BuildContext context, String email, String password) async {
    _loginProcessing = true;
    notifyListeners();
    try {
      final taskDataService = await _authService.login(email, password);
      return taskDataService;
    } on FormatException catch (e) {
      _message = '''ログインに失敗しました
エラー:${e.message}''';
      _loginProcessing = false;
      notifyListeners();
      return null;
    }
  }

  Future<void> onRegisterPressed(BuildContext context) async {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => RegisterViewProvider()));
    return;
  }

  bool get loginProcessing => _loginProcessing;

  String? get message => _message;
}
