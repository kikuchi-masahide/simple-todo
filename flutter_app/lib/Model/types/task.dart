class Task {
  final int id;
  String title;
  DateTime? limit;
  int? parentId;
  bool done;
  Task(this.id, this.title, this.limit, this.parentId, [this.done = false]);
  Task.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        title = json["title"],
        limit = (json["limit"] != null ? DateTime.parse(json["limit"]) : null),
        parentId = json["parent_id"],
        done = json["done"] ?? false;
  Task.copy(Task task)
      : id = task.id,
        title = task.title,
        limit = task.limit,
        parentId = task.parentId,
        done = task.done;
}
