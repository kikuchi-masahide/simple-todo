import 'package:flutter/material.dart';
import 'package:flutter_app/model/service/task_data_service.dart';
import 'package:flutter_app/model/types/tasks_scroll_list_item_info.dart';

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

  List<TasksScrollListItemInfo> getTasksScrollListItemInfos() {
    List<TasksScrollListItemInfo> ret = [];
    _taskDataService.iterateTaskTrees((task) {
      ret.add(TasksScrollListItemInfo(
          task.id, task.title, task.done, 0, TasksScrollListItemExpand.yes));
      return true;
    });
    return ret;
  }
}
