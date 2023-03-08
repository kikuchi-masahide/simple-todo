import 'package:flutter_app/model/service/tasks_trees.dart';
import 'package:flutter_app/model/types/task.dart';

///TaskDataService内部で行う1まとめのタスク操作をまとめ、redo可能にする
abstract class TaskCommand {
  ///更新が行われたか否かを返す(falseならばredo可能にするべき変更として扱わない)
  bool execute(Map<int, Task> tasks, TasksTrees trees);
  void undo(Map<int, Task> tasks, TasksTrees trees);
}
