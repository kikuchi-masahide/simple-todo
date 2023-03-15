import 'package:flutter/material.dart';
import 'package:flutter_app/model/service/task_data_service.dart';
import 'package:flutter_app/model/types/edit_mode.dart';
import 'package:flutter_app/model/types/edit_view_info.dart';
import 'package:flutter_app/model/types/task_dropdown_button_item_info.dart';
import 'package:flutter_app/model/types/task.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

class EditViewModel extends ChangeNotifier {
  final TaskDataService _taskDataService;
  final int? _id;
  late bool _limitCheckboxValue;
  bool get limitCheckboxValue => _limitCheckboxValue;
  late DateTime? _limit;
  DateTime? get limit => _limit;
  late int? _parentID;
  int? get parentID => _parentID;
  set parentID(int? p) {
    _parentID = p;
    notifyListeners();
  }

  EditViewModel(this._taskDataService, this._id) {
    if (_id != null) {
      var task = _taskDataService.getTaskData(_id!);
      _limitCheckboxValue = task.limit != null;
      _limit = task.limit;
      _parentID = task.parentId;
    } else {
      _limitCheckboxValue = false;
      _limit = null;
      _parentID = null;
    }
    _taskDataService.registerListener(() {
      notifyListeners();
    });
  }

  EditMode getEditMode() {
    return _id == null ? EditMode.create : EditMode.edit;
  }

  EditViewInfo getEditViewInfo() {
    Task? task = _id != null ? _taskDataService.getTaskData(_id!) : null;
    var parentInfos = [
      TaskDropdownButtonItemInfo('-', null),
    ];
    _taskDataService.iterateTaskTrees((t, _) {
      if (t.id != task?.id) {
        parentInfos.add(TaskDropdownButtonItemInfo(t.title, t.id));
      }
      return true;
    });
    return EditViewInfo(task?.title ?? '', parentInfos);
  }

  ///(日時設定ダイアログを開く可能性があるためBuildContextを受け取る)
  void setLimitCheckboxValue(BuildContext context, bool? v) {
    _limitCheckboxValue = v!;
    if (_limitCheckboxValue && _limit == null) {
      openDateTimePicker(context);
    }
    notifyListeners();
  }

  void openDateTimePicker(BuildContext context) {
    DatePicker.showDateTimePicker(context, onConfirm: (DateTime? d) {
      _limit = d;
      notifyListeners();
    });
  }
}
