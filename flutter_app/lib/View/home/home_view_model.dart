import 'package:flutter/material.dart';
import 'package:flutter_app/model/service/task_data_service.dart';

class HomeViewModel extends ChangeNotifier {
  TaskDataService _taskDataService;

  HomeViewModel(this._taskDataService);
}
