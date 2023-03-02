import 'package:flutter/material.dart';
import 'package:flutter_app/model/service/auth_service.dart';

class RegisterViewModel extends ChangeNotifier {
  final AuthService _authService;

  ///登録処理中か否か
  late bool _registerProcessing;

  ///画面上部に表示するメッセージ
  late String? _message;

  RegisterViewModel(this._authService) {
    _registerProcessing = false;
    _message = null;
  }

  Future<void> register(
      BuildContext context, String email, String password) async {
    _registerProcessing = true;
    notifyListeners();
    try {
      final String token = await _authService.register(email, password);
      _message = '登録に成功しました';
    } on FormatException catch (e) {
      _message = '''登録に失敗しました
エラー:${e.message}''';
    } finally {
      _registerProcessing = false;
      notifyListeners();
    }

    ///ホーム画面への遷移
    return;
  }

  bool get registerProcessing => _registerProcessing;

  String? get message => _message;
}
