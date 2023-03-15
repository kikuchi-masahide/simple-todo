import 'package:flutter/material.dart';
import 'package:flutter_app/model/types/task_dropdown_button_item_info.dart';
import 'package:flutter_app/view/edit/edit_view_model.dart';
import 'package:provider/provider.dart';

class TaskDropdownButton extends StatelessWidget {
  final List<TaskDropdownButtonItemInfo> _infos;
  final int? _initialID;

  const TaskDropdownButton(this._infos, this._initialID, {super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const Text(
          '親タスク',
          style: TextStyle(fontSize: 20.0),
        ),
        const Padding(padding: EdgeInsets.only(left: 10.0, right: 10.0)),
        DropdownButton(
          items: _infos.map((e) => _getTaskDropdownButtonItem(e)).toList(),
          value: _initialID,
          onChanged: (id) {
            context.read<EditViewModel>().parentID = id;
          },
        )
      ],
    );
  }

  DropdownMenuItem<int?> _getTaskDropdownButtonItem(
      TaskDropdownButtonItemInfo info) {
    return DropdownMenuItem(
      value: info.id,
      child: Text(info.title),
    );
  }
}
