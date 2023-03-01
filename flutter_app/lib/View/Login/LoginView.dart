import 'package:flutter/material.dart';
import 'package:flutter_app/View/Login/LoginViewModel.dart';
import 'package:provider/provider.dart';
import 'package:flutter_app/Model/DB/db_proxy.dart';

class LoginView extends StatelessWidget
{
  @override
  Widget build(BuildContext context)
  {
    return Column(
      children: [
        Text('LoginView',style: TextStyle(fontSize: 32.0),),
        Text('from LoginViewModel:${context.read<LoginViewModel>().message}',style: TextStyle(fontSize: 24.0),),
        Text('from DBProxy:${context.read<DBProxy>().name()}',style:TextStyle(fontSize: 24.0)),
      ],
    );
  }
}