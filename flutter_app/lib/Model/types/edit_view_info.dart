import 'package:flutter_app/model/types/task_dropdown_button_item_info.dart';

class EditViewInfo {
  final String title;
  final List<TaskDropdownButtonItemInfo> allParents;

  EditViewInfo(this.title, this.allParents);
}
