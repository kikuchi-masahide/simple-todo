import 'package:flutter/material.dart';

abstract class DBProxy with ChangeNotifier {
  Future<String> login(String email, String password);
  Future<String> register(String email, String password);
}
