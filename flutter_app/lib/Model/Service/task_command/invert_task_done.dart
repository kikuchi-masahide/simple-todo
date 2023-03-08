import 'package:flutter_app/model/service/task_command/task_command.dart';
import 'package:flutter_app/model/service/tasks_trees.dart';
import 'package:flutter_app/model/types/task.dart';

///1つのタスクの完了/未完了の切り替え
class InvertTaskDone extends TaskCommand {
  final int _targetID;
  //未完了にしたタスクIDの配列(自分含)
  final List<int> _turnOffed = [];

  InvertTaskDone(this._targetID);

  @override
  bool execute(Map<int, Task> _tasks, TasksTrees _trees) {
    var task = _tasks[_targetID]!;
    if (task.done) {
      //完了 -> 未完了
      //自分と親のチェックを外していく
      while (true) {
        if (task.done) {
          task.done = false;
          _turnOffed.add(task.id);
        } else {
          break;
        }
        var parentId = task.parentId;
        if (parentId != null) {
          task = _tasks[parentId]!;
        } else {
          break;
        }
      }
      return true;
    } else {
      //子の側のチェック
      var childs = _trees.doAllChildsSatisfy(_targetID, (p0) => p0.done);
      if (childs) {
        task.done = true;
        return true;
      }
      return false;
    }
  }

  @override
  void undo(Map<int, Task> tasks, TasksTrees trees) {
    var task = tasks[_targetID]!;
    if (task.done) {
      task.done = false;
    } else {
      for (var id in _turnOffed) {
        tasks[id]!.done = true;
      }
    }
  }
}
