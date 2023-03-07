import 'package:flutter/material.dart';
import 'package:flutter_app/model/types/task.dart';

abstract class DBProxy extends ChangeNotifier{
  Future<String> login(String email, String password);
  Future<String> register(String email, String password);
  Future<List<Task>> getAllTasks(String token);
}
