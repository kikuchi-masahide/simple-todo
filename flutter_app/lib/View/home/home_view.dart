import 'package:flutter/material.dart';
import 'package:flutter_app/model/service/task_data_service.dart';
import 'package:flutter_app/view/component/normal_button.dart';
import 'package:flutter_app/view/component/tasks_scroll_list.dart';
import 'package:flutter_app/view/home/home_view_model.dart';
import 'package:provider/provider.dart';

class HomeView extends StatelessWidget {
  HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<HomeViewModel>().initTaskDataService();
    return Scaffold(
      appBar: AppBar(
          title: const Text(
        'ホーム',
        style: TextStyle(fontSize: 24.0),
      )),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          TasksScrollList(context
              .select((HomeViewModel model) => model.getReadonlyTasksList())),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              NormalButton('+', () {}, true),
              NormalButton('全て完了', () {}, true),
            ],
          )
        ],
      ),
    );
  }
}
