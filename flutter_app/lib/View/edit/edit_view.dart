import 'package:flutter/material.dart';
import 'package:flutter_app/model/types/edit_mode.dart';
import 'package:flutter_app/view/component/labeled_icon_button.dart';
import 'package:flutter_app/view/component/normal_text_field.dart';
import 'package:flutter_app/view/component/task_dropdown_button.dart';
import 'package:flutter_app/view/edit/edit_view_model.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class EditView extends StatelessWidget {
  final _titleController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var info = context.read<EditViewModel>().getEditViewInfo();
    _titleController.text = info.title;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _getAppBarTitle(context.read<EditViewModel>().getEditMode()),
          style: const TextStyle(fontSize: 24.0),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 20.0, right: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            NormalTextField(_titleController, '名前', true),
            _buildLimitSelector(context),
            Padding(
              padding: const EdgeInsets.all(40.0),
              child: TaskDropdownButton(info.allParents),
            ),
          ],
        ),
      ),
    );
  }

  String _getAppBarTitle(EditMode editMode) {
    switch (editMode) {
      case EditMode.create:
        return '新規作成';
      case EditMode.edit:
        return '編集';
    }
  }

  void Function(bool?) _onLimitCheckboxChanged(BuildContext context) {
    return (bool? v) {
      context.read<EditViewModel>().setLimitCheckboxValue(context, v);
    };
  }

  Widget _buildLimitSelector(BuildContext context) {
    var limitCheckboxValue = context.watch<EditViewModel>().limitCheckboxValue;
    var limit = context.watch<EditViewModel>().limit;
    var children = [
      Checkbox(
          value: limitCheckboxValue,
          onChanged: _onLimitCheckboxChanged(context)),
      const Text(
        '期限を設定する',
        style: TextStyle(fontSize: 20.0),
      ),
    ];
    if (limit != null) {
      children.addAll([
        const Padding(padding: EdgeInsets.only(left: 10.0, right: 10.0)),
        Text(
          DateFormat('yyyy-MM-dd HH:mm:ss').format(limit),
          style: TextStyle(
              fontSize: 20.0,
              color: limitCheckboxValue ? Colors.black : Colors.grey),
        ),
        LabeledIconButton(Icons.schedule, '時刻変更', () {
          context.read<EditViewModel>().openDateTimePicker(context);
        }, context.watch<EditViewModel>().limitCheckboxValue),
      ]);
    }
    return Padding(
      padding: const EdgeInsets.only(left: 40.0, right: 40.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }
}
