import 'package:flutter/material.dart';
import 'package:flutter_app/model/service/task_data_service.dart';
import 'package:flutter_app/view/edit/edit_view.dart';
import 'package:flutter_app/view/edit/edit_view_model.dart';
import 'package:provider/provider.dart';

class EditViewProvider extends StatelessWidget {
  final TaskDataService _taskDataService;
  final int? _id;

  const EditViewProvider(this._taskDataService, this._id, {super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (_) => EditViewModel(_taskDataService, _id)),
      ],
      child: EditView(),
    );
  }
}
