///各タスクが子を持つか、持つならばそれを表示するか否か
enum TasksScrollListItemExpand {
  ///子を持たない
  none,

  ///子を表示する
  yes,

  ///子を表示しない
  no,
}

class TasksScrollListItemInfo {
  final int id;
  final String title;
  final bool done;
  final int depth;
  final TasksScrollListItemExpand expand;

  TasksScrollListItemInfo(
      this.id, this.title, this.done, this.depth, this.expand);
}
