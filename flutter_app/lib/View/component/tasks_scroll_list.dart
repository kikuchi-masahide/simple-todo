import 'package:flutter/material.dart';
import 'package:flutter_app/model/types/Task.dart';

class TasksScrollList extends StatelessWidget {
  List<Task> _tasks;

  TasksScrollList(this._tasks, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: _tasks
          .map((task) => Text(
                task.title,
                style: TextStyle(fontSize: 24.0),
              ))
          .toList(),
    ));
  }
}
