import 'package:flutter/material.dart';
import 'package:flutter_app/Model/DB/db_proxy.dart';
import 'package:flutter_app/Model/DB/local_db.dart';
import 'package:flutter_app/Model/Service/auth_service.dart';
import 'package:flutter_app/View/Login/LoginViewProvider.dart';
import 'package:provider/provider.dart';

void main()
{
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider<DBProxy>(create: (_) => LocalDB()),
      ChangeNotifierProvider(create: (_) => AuthService()),
    ],
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget
{
  @override
  Widget build(BuildContext context)
  {
    return MaterialApp(
      title: 'simple-todo',
      initialRoute: '/login',
      routes: {
        '/login': (context) => LoginViewProvider(),
      },
    );
  }
}