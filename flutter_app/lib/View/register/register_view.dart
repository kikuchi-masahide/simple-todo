import 'package:flutter/material.dart';
import 'package:flutter_app/view/component/box_alert.dart';
import 'package:flutter_app/view/component/normal_button.dart';
import 'package:flutter_app/view/component/normal_text_field.dart';
import 'package:flutter_app/view/register/register_view_model.dart';
import 'package:provider/provider.dart';

class RegisterView extends StatelessWidget {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            '新規登録',
            style: TextStyle(fontSize: 24.0),
          ),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            BoxAlert(
                context.select((RegisterViewModel model) => model.message)),
            NormalTextField(
                _emailController,
                'メールアドレス',
                context.select(
                    (RegisterViewModel model) => !model.registerProcessing)),
            const Padding(padding: EdgeInsets.all(20.0)),
            NormalTextField(
                _passwordController,
                'パスワード',
                context.select(
                    (RegisterViewModel model) => !model.registerProcessing),
                true),
            const Padding(padding: EdgeInsets.all(20.0)),
            NormalButton('登録', () async {
              _onRegisterPressed(context);
            },
                context.select(
                    (RegisterViewModel model) => !model.registerProcessing)),
          ],
        ));
  }

  void _onRegisterPressed(BuildContext context) async {
    await context
        .read<RegisterViewModel>()
        .register(context, _emailController.text, _passwordController.text);
  }
}
