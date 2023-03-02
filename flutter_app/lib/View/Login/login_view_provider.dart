import 'package:flutter/material.dart';
import 'package:flutter_app/model/service/auth_service.dart';
import 'package:flutter_app/view/login/login_view.dart';
import 'package:flutter_app/view/login/login_view_model.dart';
import 'package:provider/provider.dart';

class LoginViewProvider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => LoginViewModel(context.read<AuthService>()),
      child: LoginView(),
    );
  }
}
