import 'package:flutter/material.dart';
import 'package:flutter_app/View/Login/login_view_model.dart';
import 'package:provider/provider.dart';

class LoginView extends StatelessWidget {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text(
        'ログイン',
        style: TextStyle(fontSize: 24.0),
      )),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text('メールアドレス'),
            TextField(
              controller: _emailController,
            ),
            const Text('パスワード'),
            TextField(
              controller: _passwordController,
              obscureText: true,
            ),
            TextButton(
              onPressed: () => _onLoginPressed(context),
              child: const Text('ログイン'),
            )
          ],
        ),
      ),
    );
  }

  ///ログインボタンが押された時の挙動
  void _onLoginPressed(BuildContext context) async {
    await context
        .read<LoginViewModel>()
        .login(context, _emailController.text, _passwordController.text)
        .then((_) => showDialog(
            context: context,
            builder: (c) => const AlertDialog(
                title: Text('ログイン成功'), content: Text('ログインに成功しました'))))
        .catchError((e) => showDialog(
            context: context,
            builder: (c) => AlertDialog(
                title: const Text('ログイン失敗'),
                content: Text('ログインに失敗しました　エラー:$e'))));
  }
}
