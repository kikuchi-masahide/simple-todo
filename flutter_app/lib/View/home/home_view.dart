import 'package:flutter/material.dart';
import 'package:flutter_app/view/component/normal_button.dart';
import 'package:flutter_app/view/component/tasks_scroll_list.dart';

class HomeView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
          TasksScrollList(),
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
