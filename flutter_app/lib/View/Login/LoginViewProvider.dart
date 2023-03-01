import 'package:flutter/material.dart';
import 'package:flutter_app/View/Login/LoginView.dart';
import 'package:flutter_app/View/Login/LoginViewModel.dart';
import 'package:provider/provider.dart';

class LoginViewProvider extends StatelessWidget
{
  @override
  Widget build(BuildContext context)
  {
    return ChangeNotifierProvider(
      create: (_) => LoginViewModel(),
      child: LoginView(),
    );
  }
}