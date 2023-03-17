import 'package:flutter_app/model/service/task_command/task_command.dart';
import 'package:flutter_app/model/service/tasks_trees.dart';
import 'package:flutter_app/model/types/task.dart';
import 'dart:math' as math;

class CreateTask extends TaskCommand {
  late int _id;
  final String _title;
  final DateTime? _limit;
  final int? _parentID;
  CreateTask(this._title, this._limit, this._parentID);

  @override
  bool execute(Map<int, Task> tasks, TasksTrees trees) {
    ///IDはランダム生成
    var random = math.Random();
    int id;
    do {
      id = random.nextInt(1000000000);
    } while (tasks.containsKey(id));
    _id = id;
    var task = Task(id, _title, _limit, _parentID);
    tasks[task.id] = task;
    trees.addElement(task);
    return true;
  }

  @override
  void undo(Map<int, Task> tasks, TasksTrees trees) {
    tasks.remove(_id);
    trees.deleteElement(_id);
  }
}
