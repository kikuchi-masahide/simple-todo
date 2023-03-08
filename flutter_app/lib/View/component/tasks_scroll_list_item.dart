import 'package:flutter/material.dart';
import 'package:flutter_app/model/types/tasks_scroll_list_item_expand.dart';
import 'package:flutter_app/model/types/tasks_scroll_list_item_info.dart';
import 'package:flutter_app/view/home/home_view_model.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class TasksScrollListItem extends StatefulWidget {
  final TasksScrollListItemInfo _info;

  const TasksScrollListItem(this._info, {super.key});

  @override
  _TasksScrollListItemState createState() => _TasksScrollListItemState(_info);
}

class _TasksScrollListItemState extends State<TasksScrollListItem> {
  final TasksScrollListItemInfo _info;
  static const _paddingPerDepth = 20.0;
  static const _expandIconYes = Icons.expand_more;
  static const _expandIconNo = Icons.chevron_right;
  static const _taskTitleFontSize = 20.0;
  static const _taskTitleColorLimitExceeded = Colors.grey;
  static const _taskTitleColorLimitNonexceeded = Colors.black;
  static const _taskLimitFontSize = 15.0;
  static const _taskLimitColor = Colors.grey;

  _TasksScrollListItemState(this._info);

  @override
  Widget build(BuildContext context) {
    final List<Widget> children = [
      Checkbox(
        value: context.select(
            (HomeViewModel model) => model.getTaskCheckboxValue(_info.id)),
        onChanged: _onCheckboxChanged,
      ),
      Padding(padding: EdgeInsets.only(left: _paddingPerDepth * _info.depth)),
    ];
    var iconData = _getExpandIconData();
    if (iconData != null) {
      children.add(GestureDetector(
        onTap: _onExpandTapped,
        child: Icon(iconData),
      ));
    }
    children.add(GestureDetector(
      onTap: _onTaskTapped,
      child: _getTaskTitleText(),
    ));
    var taskLimitText = _getTaskLimitText();
    if (taskLimitText != null) {
      children.add(taskLimitText);
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      children: children,
    );
  }

  void _onCheckboxChanged(bool? v) {
    context.read<HomeViewModel>().setTaskCheckboxValue(_info.id, v ?? false);
  }

  void _onExpandTapped() {
    context.read<HomeViewModel>().onTasksScrollListItemExpandTapped(_info.id);
  }

  void _onTaskTapped() {
    context.read<HomeViewModel>().onTasksScrollListItemTapped(_info.id);
  }

  IconData? _getExpandIconData() {
    var expand =
        context.watch<HomeViewModel>().getTasksScrollListItemExpand(_info.id);
    if (expand == TasksScrollListItemExpand.yes) {
      return _expandIconYes;
    } else if (expand == TasksScrollListItemExpand.no) {
      return _expandIconNo;
    } else {
      return null;
    }
  }

  Text _getTaskTitleText() {
    return Text(
      _info.title,
      style: TextStyle(
        fontSize: _taskTitleFontSize,
        decoration:
            _info.done ? TextDecoration.lineThrough : TextDecoration.none,
        color: _info.limit != null && _info.limit!.isBefore(DateTime.now())
            ? _taskTitleColorLimitExceeded
            : _taskTitleColorLimitNonexceeded,
      ),
    );
  }

  Text? _getTaskLimitText() {
    if (_info.limit != null) {
      var limitFormated =
          '~${DateFormat('yyyy-MM-dd HH:mm').format(_info.limit!)}';
      return Text(
        limitFormated,
        style: const TextStyle(
          fontSize: _taskLimitFontSize,
          color: _taskLimitColor,
        ),
      );
    }
    return null;
  }
}
