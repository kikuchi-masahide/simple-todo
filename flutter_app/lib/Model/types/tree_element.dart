import 'package:flutter_app/model/types/task.dart';

///木を構成する要素
class TreeElement {
  final Task _task;
  TreeElement? parent;
  final List<TreeElement> childs;
  TreeElement(this._task, this.parent) : childs = [];
  Task get task => Task.copy(_task);
}
