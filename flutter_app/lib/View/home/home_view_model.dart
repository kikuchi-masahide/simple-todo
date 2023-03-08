import 'package:flutter/material.dart';
import 'package:flutter_app/model/service/task_data_service.dart';
import 'package:flutter_app/model/types/tasks_scroll_list_item_expand.dart';
import 'package:flutter_app/model/types/tasks_scroll_list_item_info.dart';

class HomeViewModel extends ChangeNotifier {
  final TaskDataService _taskDataService;
  bool _initTaskDataService = false;
  final _taskCheckboxValue = <int, bool>{};
  final _taskExpand = <int, TasksScrollListItemExpand>{};

  HomeViewModel(this._taskDataService);

  void initTaskDataService() {
    if (!_initTaskDataService) {
      _initTaskDataService = true;
      _taskDataService.initTasks().then((_) {
        _taskDataService.iterateTaskTrees((task, _) {
          _taskCheckboxValue[task.id] = false;
          if (_taskDataService.hasChilds(task.id)) {
            _taskExpand[task.id] = TasksScrollListItemExpand.no;
          } else {
            _taskExpand[task.id] = TasksScrollListItemExpand.none;
          }
          return true;
        });
        notifyListeners();
      });
    }
  }

  List<TasksScrollListItemInfo> getTasksScrollListItemInfos() {
    List<TasksScrollListItemInfo> ret = [];
    _taskDataService.iterateTaskTrees((task, depth) {
      ret.add(TasksScrollListItemInfo(
          task.id, task.title, task.done, task.limit, depth));
      return _taskExpand[task.id] == TasksScrollListItemExpand.yes;
    });
    return ret;
  }

  bool getTaskCheckboxValue(int id) {
    return _taskCheckboxValue[id]!;
  }

  void setTaskCheckboxValue(int id, bool v) {
    _taskCheckboxValue[id] = v;
    notifyListeners();
  }

  TasksScrollListItemExpand getTasksScrollListItemExpand(int id) {
    return _taskExpand[id]!;
  }

  void onTasksScrollListItemExpandTapped(int id) {
    TasksScrollListItemExpand old = _taskExpand[id]!;
    if (old == TasksScrollListItemExpand.yes) {
      _taskExpand[id] = TasksScrollListItemExpand.no;
      notifyListeners();
    } else if (old == TasksScrollListItemExpand.no) {
      _taskExpand[id] = TasksScrollListItemExpand.yes;
      notifyListeners();
    }
  }

  void onTasksScrollListItemTapped(int id) {
    //TODO:_taskDataServiceに変更を加えたならば、その内部からnotifyListeners()を発するべき やはりProviderにTaskDataServiceを加えるべきか?
    _taskDataService.onTaskDoneInvert(id);
    notifyListeners();
  }
}
