import 'package:flutter_app/model/db/db_proxy.dart';
import 'package:flutter_app/model/service/tasks_trees.dart';
import 'package:flutter_app/model/types/task.dart';

/**
 * 単一のトークンに対するデータ処理
 */
class TaskDataService {
  String _token;
  final DBProxy _dbProxy;

  ///id => task
  Map<int, Task> _tasks;
  TasksTrees _trees;

  TaskDataService(this._token, this._dbProxy)
      : _tasks = {},
        _trees = TasksTrees();

  Future<void> initTasks() async {
    final tasksList = await _dbProxy.getAllTasks(_token);
    for (var task in tasksList) {
      _tasks[task.id] = task;
    }
    _trees.init(_tasks);
    _trees.sortWith(_limitAscSort);
  }

  ///全Task eのコピーに対して木構造の深さ優先でfunc(e)を実行
  ///返り値がfalseの場合、子に対し実行を行わない
  void iterateTaskTrees(bool Function(Task) func) {
    _trees.iterate((id) => func(_copy(_tasks[id] as Task)));
  }

  //このIDのタスクが子を持つか
  bool hasChilds(int id) {
    return _trees.hasChilds(id);
  }

  Task _copy(Task t) {
    return Task(t.id, t.title, t.limit, t.parentId, t.done);
  }

  int _limitAscSort(int p0, int p1) {
    var task0 = _tasks[p0] as Task;
    var task1 = _tasks[p1] as Task;
    var limit0 = task0.limit;
    var limit1 = task1.limit;
    if (limit0 != null) {
      if (limit1 != null) {
        return limit0.compareTo(limit1);
      } else {
        return -1;
      }
    } else {
      if (limit1 != null) {
        return 1;
      } else {
        return task0.id - task1.id;
      }
    }
  }
}
