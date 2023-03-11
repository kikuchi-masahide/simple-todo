import 'dart:collection';
import 'package:flutter_app/model/service/task_command/task_command.dart';
import 'package:flutter_app/model/service/tasks_trees.dart';
import 'package:flutter_app/model/types/task.dart';

class DoneSelectedTasks extends TaskCommand {
  final Set<int> _selectedIDs;
  //実際にexecuteで完了したタスクID
  final Set<int> _checkedIDs;
  DoneSelectedTasks(this._selectedIDs)
      : _checkedIDs = {},
        super();

  @override
  bool execute(Map<int, Task> tasks, TasksTrees trees) {
    //選択済みタスク全ての深さを調べ、深さの深いものから完了していく
    //一度調べたタスクIDをメモ化 nullを深さ-1とする
    Map<int?, int> depth = {};
    depth[null] = -1;
    for (var id in _selectedIDs) {
      //0番目要素から順に深さを調べる
      var index = Queue();
      int? cur = id;
      while (true) {
        if (depth.containsKey(cur)) {
          break;
        }
        index.addFirst(cur);
        cur = tasks[cur]!.parentId;
      }
      while (index.isNotEmpty) {
        cur = index.removeFirst();
        var parentId = tasks[cur]!.parentId;
        depth[cur] = depth[parentId]! + 1;
      }
    }
    //1つでも変更があったか
    bool changed = false;
    //0番目から順にチェック
    var index = _selectedIDs.toList();
    index.sort((a, b) => depth[b]! - depth[a]!);
    for (var id in index) {
      if (trees.doAllChildsSatisfy(id, (task) => task.done)) {
        if (!tasks[id]!.done) {
          tasks[id]!.done = true;
          _checkedIDs.add(id);
          changed = true;
        }
      }
    }
    return changed;
  }

  @override
  void undo(Map<int, Task> tasks, TasksTrees trees) {
    for (var id in _checkedIDs) {
      tasks[id]!.done = false;
    }
  }
}
