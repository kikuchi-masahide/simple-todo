import 'package:flutter/material.dart';
import 'package:flutter_app/model/service/task_data_service.dart';
import 'package:flutter_app/model/types/tasks_scroll_list_item_expand.dart';
import 'package:flutter_app/model/types/tasks_scroll_list_item_info.dart';

class HomeViewModel extends ChangeNotifier {
  final TaskDataService _taskDataService;
  bool _initTaskDataService = false;
  final Set<int> _selectedTaskID = {};
  final _taskExpand = <int, TasksScrollListItemExpand>{};
  bool _selectMode = false;

  HomeViewModel(this._taskDataService);

  void initTaskDataService() {
    if (!_initTaskDataService) {
      _initTaskDataService = true;
      _taskDataService.registerListener(() {
        notifyListeners();
      });
      _taskDataService.initTasks().then((_) {
        _taskDataService.iterateTaskTrees((task, _) {
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

  bool isSelected(int id) {
    return _selectedTaskID.contains(id);
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
    if (!_selectMode) {
      _taskDataService.onTaskDoneInvert(id);
    } else {
      if (_selectedTaskID.contains(id)) {
        _selectedTaskID.remove(id);
      } else {
        _selectedTaskID.add(id);
      }
      notifyListeners();
    }
  }

  void onTasksScrollListItemLongPressed(int id) {
    _selectMode = true;
    _selectedTaskID.add(id);
    notifyListeners();
  }

  void quitSelectMode() {
    _selectMode = false;
    _selectedTaskID.clear();
    notifyListeners();
  }

  bool get selectMode => _selectMode;

  void undo() {
    _taskDataService.undo();
  }

  bool isUndoable() {
    return _taskDataService.isUndoable();
  }
}
