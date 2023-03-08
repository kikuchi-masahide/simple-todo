import 'package:flutter/material.dart';
import 'package:flutter_app/view/component/normal_button.dart';
import 'package:flutter_app/view/component/tasks_scroll_list.dart';
import 'package:flutter_app/view/home/home_view_model.dart';
import 'package:provider/provider.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<HomeViewModel>().initTaskDataService();
    return Scaffold(
      appBar: AppBar(
          title: const Text(
        'ホーム',
        style: TextStyle(fontSize: 24.0),
      )),
      body: Container(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TasksScrollList(
                context.watch<HomeViewModel>().getTasksScrollListItemInfos()),
            const Padding(padding: EdgeInsets.all(10.0)),
            _buildBottomWidgets(context),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomWidgets(BuildContext context) {
    var children = <Widget>[];
    if (!context.watch<HomeViewModel>().selectMode) {
      children = [
        NormalButton('+', () {}, true),
        _buildUndoButton(context),
      ];
    } else {
      children = [
        TextButton(
            onPressed: _onBackButtonPressed(context),
            child: const Icon(Icons.arrow_back)),
      ];
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: children,
    );
  }

  Widget _buildUndoButton(BuildContext context) {
    bool undoable = context.watch<HomeViewModel>().isUndoable();
    return TextButton(
      onPressed: undoable ? _onUndoButtonPressed(context) : null,
      child: const Icon(
        Icons.undo,
      ),
    );
  }

  void Function() _onBackButtonPressed(BuildContext context) {
    return () {
      context.read<HomeViewModel>().quitSelectMode();
    };
  }

  void Function() _onUndoButtonPressed(BuildContext context) {
    return () {
      context.read<HomeViewModel>().undo();
    };
  }
}
