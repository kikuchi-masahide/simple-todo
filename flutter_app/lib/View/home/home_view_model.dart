import 'package:flutter/material.dart';
import 'package:flutter_app/model/service/task_data_service.dart';
import 'package:flutter_app/model/types/Task.dart';

class HomeViewModel extends ChangeNotifier {
  final TaskDataService _taskDataService;
  bool _initTaskDataService = false;

  HomeViewModel(this._taskDataService);

  void initTaskDataService() {
    if (!_initTaskDataService) {
      _initTaskDataService = true;
      _taskDataService.initTasks().then((_) {
        notifyListeners();
      });
    }
  }

  List<Task> getReadonlyTasksList() {
    return _taskDataService.getReadonlyTasksList();
  }
}
