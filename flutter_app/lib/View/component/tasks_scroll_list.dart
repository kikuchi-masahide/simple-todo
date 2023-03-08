import 'package:flutter/material.dart';
import 'package:flutter_app/model/types/tasks_scroll_list_item_info.dart';
import 'package:flutter_app/view/component/tasks_scroll_list_item.dart';

class TasksScrollList extends StatelessWidget {
  final List<TasksScrollListItemInfo> _tasks;

  const TasksScrollList(this._tasks, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var scroll = SingleChildScrollView(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: _tasks
          .map((task) => TasksScrollListItem(
                task,
                key: ValueKey(task),
              ))
          .toList(),
    ));
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.all(5.0),
      height: 300.0,
      width: 450.0,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black),
        borderRadius: const BorderRadius.all(Radius.circular(5.0)),
      ),
      child: scroll,
    );
  }
}
