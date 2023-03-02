import 'package:flutter/material.dart';
import 'package:flutter_app/Model/Service/auth_service.dart';
import 'package:flutter_app/View/Login/login_view.dart';
import 'package:flutter_app/View/Login/login_view_model.dart';
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
