import 'package:flutter/material.dart';
import 'package:flutter_app/model/types/tasks_scroll_list_item_info.dart';

class TasksScrollListItem extends StatelessWidget {
  final TasksScrollListItemInfo _info;
  final bool _checked;

  const TasksScrollListItem(this._info, {super.key}) : _checked = false;

  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          Checkbox(
            value: _checked,
            onChanged: (v) => {},
          ),
          Text(
            _info.title,
            style: TextStyle(
              fontSize: 20.0,
            ),
          ),
        ],
      ),
    );
  }
}
