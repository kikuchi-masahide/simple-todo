import 'package:flutter/material.dart';
import 'package:flutter_app/view/component/labeled_icon_button.dart';
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
        LabeledIconButton(Icons.add, '追加', () {}, true),
        _buildUndoButton(context),
      ];
    } else {
      children = [
        LabeledIconButton(
            Icons.arrow_back, '戻る', _onBackButtonPressed(context), true),
        LabeledIconButton(Icons.done_all, '全て完了',
            _onDoneSelectedTasksButtonPressed(context), true),
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
    return LabeledIconButton(
        Icons.undo, '戻す', _onUndoButtonPressed(context), undoable);
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

  void Function() _onDoneSelectedTasksButtonPressed(BuildContext context) {
    return () {
      context.read<HomeViewModel>().onDoneSelectedTasksButtonPressed();
    };
  }
}
