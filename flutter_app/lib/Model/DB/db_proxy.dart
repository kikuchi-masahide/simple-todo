import 'package:flutter/material.dart';

abstract class DBProxy with ChangeNotifier {
  Future<String> login(String email, String password);
}
