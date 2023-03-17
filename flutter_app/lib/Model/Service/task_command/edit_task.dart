import 'package:flutter_app/model/service/task_command/task_command.dart';
import 'package:flutter_app/model/service/tasks_trees.dart';
import 'package:flutter_app/model/types/task.dart';

class EditTask extends TaskCommand {
  final int _id;
  final String _title;
  final DateTime? _limit;
  final int? _parentID;
  late String _oldTitle;
  late DateTime? _oldLimit;
  late int? _oldParentID;
  EditTask(this._id, this._title, this._limit, this._parentID);

  @override
  bool execute(Map<int, Task> tasks, TasksTrees trees) {
    var task = tasks[_id]!;
    _oldTitle = task.title;
    _oldLimit = task.limit;
    _oldParentID = task.parentId;
    task.title = _title;
    task.limit = _limit;
    task.parentId = _parentID;
    if (_oldParentID != _parentID) {
      trees.update(_id);
    }
    return _oldTitle != _title ||
        _oldLimit != _limit ||
        _oldParentID != _parentID;
  }

  @override
  void undo(Map<int, Task> tasks, TasksTrees trees) {
    var task = tasks[_id]!;
    task.title = _oldTitle;
    task.limit = _oldLimit;
    task.parentId = _oldParentID;
    if (_oldParentID != _parentID) {
      trees.update(_id);
    }
  }
}
