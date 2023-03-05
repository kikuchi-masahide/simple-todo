import 'package:flutter/material.dart';
import 'package:flutter_app/view/home/home_view.dart';
import 'package:flutter_app/view/home/home_view_model.dart';
import 'package:flutter_app/model/service/task_data_service.dart';
import 'package:provider/provider.dart';

class HomeViewProvider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var taskDataService =
        ModalRoute.of(context)!.settings.arguments as TaskDataService;
    return ChangeNotifierProvider(
      create: (_) => HomeViewModel(taskDataService),
      child: HomeView(),
    );
  }
}
