import 'package:flutter/material.dart';
import 'package:flutter_app/view/component/box_alert.dart';
import 'package:flutter_app/view/component/normal_button.dart';
import 'package:flutter_app/view/component/normal_text_field.dart';
import 'package:flutter_app/view/login/login_view_model.dart';
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
            BoxAlert(context.select((LoginViewModel model) => model.message)),
            NormalTextField(
                _emailController,
                'メールアドレス',
                context
                    .select((LoginViewModel model) => !model.loginProcessing)),
            const Padding(padding: EdgeInsets.all(20.0)),
            NormalTextField(
                _passwordController,
                'パスワード',
                context
                    .select((LoginViewModel model) => !model.loginProcessing),
                true),
            const Padding(padding: EdgeInsets.all(20.0)),
            NormalButton('ログイン', () async {
              _onLoginPressed(context);
            },
                context
                    .select((LoginViewModel model) => !model.loginProcessing)),
          ],
        ),
      ),
    );
  }

  ///ログインボタンが押された時の挙動
  void _onLoginPressed(BuildContext context) async {
    await context
        .read<LoginViewModel>()
        .login(context, _emailController.text, _passwordController.text);
  }
}
