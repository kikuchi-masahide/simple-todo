import 'package:flutter/material.dart';
import 'package:flutter_app/model/types/tasks_scroll_list_item_expand.dart';
import 'package:flutter_app/model/types/tasks_scroll_list_item_info.dart';
import 'package:flutter_app/view/home/home_view_model.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class TasksScrollListItem extends StatelessWidget {
  final TasksScrollListItemInfo _info;
  static const _paddingPerDepth = 20.0;
  static const _expandIconYes = Icons.expand_more;
  static const _expandIconNo = Icons.chevron_right;
  static const _expandIconNone = Icons.remove;
  static const _taskTitleFontSize = 20.0;
  static const _taskTitleColorLimitExceeded = Colors.grey;
  static const _taskTitleColorLimitNonexceeded = Colors.black;
  static const _taskLimitFontSize = 15.0;
  static const _taskLimitColor = Colors.grey;

  const TasksScrollListItem(this._info, {super.key});

  @override
  Widget build(BuildContext context) {
    final List<Widget> children = [
      Padding(padding: EdgeInsets.only(left: _paddingPerDepth * _info.depth)),
    ];
    var iconData = _getExpandIconData(context);
    if (iconData != null) {
      children.add(GestureDetector(
        onTap: _onExpandTapped(context),
        child: Icon(iconData),
      ));
    }
    children.add(GestureDetector(
      onTap: _onTaskTapped(context),
      onLongPress: _onTaskLongPressed(context),
      child: _getTaskTitleText(),
    ));
    var taskLimitText = _getTaskLimitText();
    if (taskLimitText != null) {
      children.add(taskLimitText);
    }
    children.add(_buildEditModeButton(context));
    return Container(
      decoration: _getWholeContainerDecoration(context),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: children,
      ),
    );
  }

  void Function() _onExpandTapped(BuildContext context) {
    return () {
      context.read<HomeViewModel>().onTasksScrollListItemExpandTapped(_info.id);
    };
  }

  void Function() _onTaskTapped(BuildContext context) {
    return () {
      context.read<HomeViewModel>().onTasksScrollListItemTapped(_info.id);
    };
  }

  void Function() _onTaskLongPressed(BuildContext context) {
    return () {
      context.read<HomeViewModel>().onTasksScrollListItemLongPressed(_info.id);
    };
  }

  IconData? _getExpandIconData(BuildContext context) {
    var expand =
        context.read<HomeViewModel>().getTasksScrollListItemExpand(_info.id);
    if (expand == TasksScrollListItemExpand.yes) {
      return _expandIconYes;
    } else if (expand == TasksScrollListItemExpand.no) {
      return _expandIconNo;
    } else {
      return _expandIconNone;
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

  Decoration? _getWholeContainerDecoration(BuildContext context) {
    if (!context.read<HomeViewModel>().selectMode) {
      return null;
    } else {
      var selected =
          context.select((HomeViewModel model) => model.isSelected(_info.id));
      if (selected) {
        return const BoxDecoration(
          color: Colors.lightBlue,
          borderRadius: BorderRadius.all(Radius.circular(2.0)),
        );
      } else {
        return null;
      }
    }
  }

  Widget _buildEditModeButton(BuildContext context) {
    return GestureDetector(
      onTap: _onEditModeButtonTapped(context),
      child: const Icon(Icons.more_vert),
    );
  }

  void Function() _onEditModeButtonTapped(BuildContext context) {
    return () {
      context.read<HomeViewModel>().navigateToEditPage(context, _info.id);
    };
  }
}
