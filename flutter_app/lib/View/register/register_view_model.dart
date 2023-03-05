import 'package:flutter/material.dart';
import 'package:flutter_app/model/service/auth_service.dart';
import 'package:flutter_app/model/service/task_data_service.dart';

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

  Future<TaskDataService?> register(
      BuildContext context, String email, String password) async {
    _registerProcessing = true;
    notifyListeners();
    try {
      final service = await _authService.register(email, password);
      return service;
    } on FormatException catch (e) {
      _message = '''登録に失敗しました
エラー:${e.message}''';
      _registerProcessing = false;
      notifyListeners();
      return null;
    }
  }

  bool get registerProcessing => _registerProcessing;

  String? get message => _message;
}
