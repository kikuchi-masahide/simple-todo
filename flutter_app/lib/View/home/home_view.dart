import 'package:flutter/material.dart';
import 'package:flutter_app/model/types/home_message_type.dart';
import 'package:flutter_app/view/component/home_message_box.dart';
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
      body: Stack(
        children: [
          Container(
            padding: const EdgeInsets.all(30.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                TasksScrollList(context
                    .watch<HomeViewModel>()
                    .getTasksScrollListItemInfos()),
                const Padding(padding: EdgeInsets.all(10.0)),
                _buildBottomWidgets(context),
              ],
            ),
          ),
          const HomeMessageBox(),
        ],
      ),
      drawer: _buildDrawer(context),
    );
  }

  Widget _buildBottomWidgets(BuildContext context) {
    var children = <Widget>[];
    if (!context.watch<HomeViewModel>().selectMode) {
      children = [
        LabeledIconButton(Icons.add, '追加', () {
          context
              .read<HomeViewModel>()
              .navigateToEditPage(context, null)
              .then((value) {
            if (value) {
              context
                  .read<HomeViewModel>()
                  .changeHomeMessage(HomeMessageType.success, 'タスクを追加しました');
            }
          });
        }, true),
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

  Drawer _buildDrawer(BuildContext context) {
    var isUploading = context.watch<HomeViewModel>().isUploading;
    var isLogouting = context.watch<HomeViewModel>().isLogouting;
    var textColor = isUploading || isLogouting ? Colors.grey : Colors.black;
    var onUploadTap = isUploading
        ? null
        : () {
            context.read<HomeViewModel>().onUploadButtonTapped(context);
          };
    var onLogoutTap = isUploading || isLogouting
        ? null
        : () {
            context
                .read<HomeViewModel>()
                .onLogoutButtonTapped(context)
                .then((_) {
              Navigator.pushNamedAndRemoveUntil(
                  context, '/login', (route) => false);
            });
          };
    return Drawer(
      child: ListView(
        shrinkWrap: true,
        padding: const EdgeInsets.all(20.0),
        children: [
          ListTile(
            leading: const Icon(Icons.arrow_circle_up),
            title: Text(
              'アップロード',
              style: TextStyle(color: textColor),
            ),
            onTap: onUploadTap,
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: Text(
              'ログアウト',
              style: TextStyle(color: textColor),
            ),
            onTap: onLogoutTap,
          )
        ],
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

  void Function() _onDoneSelectedTasksButtonPressed(BuildContext context) {
    return () {
      context.read<HomeViewModel>().onDoneSelectedTasksButtonPressed();
    };
  }
}
