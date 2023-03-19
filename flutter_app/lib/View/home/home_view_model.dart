import 'package:flutter/material.dart';
import 'package:flutter_app/model/service/task_data_service.dart';
import 'package:flutter_app/model/types/home_message_type.dart';
import 'package:flutter_app/model/types/tasks_scroll_list_item_expand.dart';
import 'package:flutter_app/model/types/tasks_scroll_list_item_info.dart';
import 'package:flutter_app/view/edit/edit_view_provider.dart';
import 'package:tuple/tuple.dart';

class HomeViewModel extends ChangeNotifier {
  final TaskDataService _taskDataService;
  bool _initTaskDataService = false;
  final Set<int> _selectedTaskID = {};
  //偶数回タップでfalse(閉じた状態),奇数回タップでtrue(開いた状態)
  final _taskExpand = <int, bool>{};
  bool _selectMode = false;
  HomeMessageType _homeMessageType = HomeMessageType.none;
  String? _homeMessage;

  HomeViewModel(this._taskDataService);

  void initTaskDataService() {
    if (!_initTaskDataService) {
      _initTaskDataService = true;
      _taskDataService.registerListener(hashCode, () {
        notifyListeners();
      });
      _taskDataService.initTasks().then((_) {
        _taskDataService.iterateTaskTrees((task, _) {
          _taskExpand[task.id] = false;
          return true;
        });
        notifyListeners();
      });
    }
  }

  @override
  void dispose() {
    _taskDataService.unregisterListener(hashCode);
    super.dispose();
  }

  List<TasksScrollListItemInfo> getTasksScrollListItemInfos() {
    List<TasksScrollListItemInfo> ret = [];
    _taskDataService.iterateTaskTrees((task, depth) {
      ret.add(TasksScrollListItemInfo(
          task.id, task.title, task.done, task.limit, depth));
      return getTasksScrollListItemExpand(task.id) ==
          TasksScrollListItemExpand.yes;
    });
    return ret;
  }

  bool isSelected(int id) {
    return _selectedTaskID.contains(id);
  }

  TasksScrollListItemExpand getTasksScrollListItemExpand(int id) {
    if (!_taskDataService.hasChilds(id)) {
      return TasksScrollListItemExpand.none;
    }
    if (_taskExpand[id]!) {
      return TasksScrollListItemExpand.yes;
    } else {
      return TasksScrollListItemExpand.no;
    }
  }

  void onTasksScrollListItemExpandTapped(int id) {
    if (!_taskDataService.hasChilds(id)) {
      return;
    }
    _taskExpand[id] = !_taskExpand[id]!;
    notifyListeners();
  }

  void onTasksScrollListItemTapped(int id) {
    if (!_selectMode) {
      _taskDataService.onTaskDoneInvert(id);
    } else {
      if (_selectedTaskID.contains(id)) {
        _selectedTaskID.remove(id);
        if (_selectedTaskID.isEmpty) {
          _selectMode = false;
        }
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

  void onDoneSelectedTasksButtonPressed() {
    _taskDataService.doneSelectedTasks(_selectedTaskID);
    quitSelectMode();
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

  ///編集ページへ移行する　編集/新規作成が行われたか否かはFutureの返り値で判断
  Future<bool> navigateToEditPage(BuildContext context, int? id) async {
    bool? result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => EditViewProvider(_taskDataService, id),
        ));
    return result ?? false;
  }

  Tuple2<HomeMessageType, String?> getHomeMessage() {
    return Tuple2(_homeMessageType, _homeMessage);
  }

  void changeHomeMessage(HomeMessageType type, String? message) {
    _homeMessageType = type;
    _homeMessage = message;
    notifyListeners();
  }

  void closeHomeMessage() {
    changeHomeMessage(HomeMessageType.none, null);
  }

  void upload(BuildContext context) {
    _taskDataService.upload().then((_) {
      changeHomeMessage(HomeMessageType.success, 'アップロードに成功しました');
    }).catchError((err) {
      changeHomeMessage(HomeMessageType.notice, 'アップロードに失敗しました:${err.message}');
    }).whenComplete(() {
      Navigator.pop(context);
    });
  }
}
