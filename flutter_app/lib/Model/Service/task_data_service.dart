import 'dart:collection';
import 'package:flutter_app/model/db/db_proxy.dart';
import 'package:flutter_app/model/service/task_command/invert_task_done.dart';
import 'package:flutter_app/model/service/task_command/task_command.dart';
import 'package:flutter_app/model/service/tasks_trees.dart';
import 'package:flutter_app/model/types/task.dart';

///TaskDataServiceのデータ変更を受け取る関数
typedef Listener = void Function();

/**
 * 単一のトークンに対するデータ処理
 */
class TaskDataService {
  final String _token;
  final DBProxy _dbProxy;

  ///id => task
  final Map<int, Task> _tasks = {};
  final TasksTrees _trees;
  //TaskCommandのスタック(undo用)
  final Queue<TaskCommand> _commands = Queue();
  final List<Listener> _listeners = [];

  TaskDataService(this._token, this._dbProxy) : _trees = TasksTrees();

  Future<void> initTasks() async {
    final tasksList = await _dbProxy.getAllTasks(_token);
    for (var task in tasksList) {
      _tasks[task.id] = task;
    }
    _trees.init(_tasks);
    _trees.sortWith(_limitAscSort);
    _notifyListeners();
  }

  ///DataServiceのデータが変更された際notifyを受け取る関数を登録
  ///(依存注入をやめTaskDataServiceをProviderとして登録しても、TaskDataServiceのnotifyListenersをHomeViewModelは受け取れない)
  void registerListener(Listener listener) {
    _listeners.add(listener);
  }

  ///全Task eのコピーに対して木構造の深さ優先でfunc(e,深さ)を実行
  ///返り値がfalseの場合、子に対し実行を行わない
  void iterateTaskTrees(bool Function(Task, int) func) {
    _trees.iterate(func);
  }

  //このIDのタスクが子を持つか
  bool hasChilds(int id) {
    return _trees.hasChilds(id);
  }

  //このタスクがタップされた(完了と非完了の入れ替え)時の処理
  void onTaskDoneInvert(int id) {
    _executeTaskCommand(InvertTaskDone(id));
  }

  void _executeTaskCommand(TaskCommand command) {
    var updated = command.execute(_tasks, _trees);
    if (updated) {
      if (_commands.length == 3) {
        _commands.removeLast();
      }
      _commands.addFirst(command);
      _notifyListeners();
    }
  }

  void undo() {
    if (_commands.isNotEmpty) {
      _commands.removeFirst().undo(_tasks, _trees);
      _notifyListeners();
    }
  }

  bool isUndoable() {
    return _commands.isNotEmpty;
  }

  void _notifyListeners() {
    for (var listener in _listeners) {
      listener();
    }
  }

  int _limitAscSort(Task task0, Task task1) {
    var limit0 = task0.limit ?? DateTime(3000);
    var limit1 = task1.limit ?? DateTime(3000);
    if (limit0.isBefore(DateTime.now())) {
      if (limit1.isBefore(DateTime.now())) {
        return limit0.compareTo(limit1);
      } else {
        return 1;
      }
    } else {
      if (limit1.isBefore(DateTime.now())) {
        return -1;
      } else {
        return limit0.compareTo(limit1);
      }
    }
  }
}
