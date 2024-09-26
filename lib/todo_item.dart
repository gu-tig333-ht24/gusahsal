class TodoItem {
  String id;
  String task;
  bool isCompleted;

  TodoItem({required this.id, required this.task, this.isCompleted = false});

  // Skapa TodoItem från JSON
  factory TodoItem.fromJson(Map<String, dynamic> json) {
    return TodoItem(
      id: json['id'],
      task: json['title'],
      isCompleted: json['done'],
    );
  }

  // Konvertera TodoItem till JSON
  Map<String, dynamic> toJson() {
    return {
      'title': task,
      'done': isCompleted,
    };
  }
}
