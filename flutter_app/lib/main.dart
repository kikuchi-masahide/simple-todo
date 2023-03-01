import 'package:flutter/material.dart';

void main()
{
  runApp(MyApp());
}

class MyApp extends StatelessWidget
{
  @override
  Widget build(BuildContext context)
  {
    return MaterialApp(
      title: 'simple-todo',
      home: Text(
        'text',
        style: TextStyle(fontSize: 32.0),
      ),
    );
  }
}