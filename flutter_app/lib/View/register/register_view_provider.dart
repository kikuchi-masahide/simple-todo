import 'package:flutter/material.dart';
import 'package:flutter_app/model/service/auth_service.dart';
import 'package:flutter_app/view/register/register_view.dart';
import 'package:flutter_app/view/register/register_view_model.dart';
import 'package:provider/provider.dart';

class RegisterViewProvider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => RegisterViewModel(context.read<AuthService>()),
      child: RegisterView(),
    );
  }
}
