class Task {
  final int id;
  String title;
  DateTime? limit;
  int? parent;
  bool done;
  Task(this.id, this.title, this.limit, this.parent, [this.done = false]);
  Task.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        title = json["title"],
        limit = json["limit"],
        parent = json["parent"],
        done = json["done"] ?? false;
}
