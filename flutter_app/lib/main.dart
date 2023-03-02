import 'package:flutter/material.dart';
import 'package:flutter_app/model/db/db_proxy.dart';
import 'package:flutter_app/model/db/local_db.dart';
import 'package:flutter_app/model/service/auth_service.dart';
import 'package:flutter_app/view/login/login_view_provider.dart';
import 'package:provider/provider.dart';

void main() {
  final DBProxy dbProxy = LocalDB();
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => AuthService(dbProxy)),
    ],
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'simple-todo',
      initialRoute: '/login',
      routes: {
        '/login': (context) => LoginViewProvider(),
      },
    );
  }
}
