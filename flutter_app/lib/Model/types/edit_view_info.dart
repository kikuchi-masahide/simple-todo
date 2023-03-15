import 'package:flutter_app/model/types/task_dropdown_button_item_info.dart';

class EditViewInfo {
  final String title;
  final DateTime? limit;
  final List<TaskDropdownButtonItemInfo> allParents;
  final int? parentID;

  EditViewInfo(this.title, this.limit, this.allParents, this.parentID);
}
