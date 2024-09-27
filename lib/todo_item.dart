class TodoItem {
  String id;
  String task;
  bool isCompleted;

  TodoItem({required this.id, required this.task, this.isCompleted = false});

  // Skapa TodoItem från JSON
  factory TodoItem.fromJson(Map<String, dynamic> json) {
    return TodoItem(
      id: json['id']?.toString() ?? '',
      task: json['title'] ?? '', // Ändrat från 'text' till 'title'
      isCompleted: json['done'] ?? false,
    );
  }

  // Konvertera TodoItem till JSON
  Map<String, dynamic> toJson() {
    return {
      'title': task, // Ändrat från 'text' till 'title'
      'done': isCompleted,
    };
  }
}
