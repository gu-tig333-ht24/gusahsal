import 'package:flutter/material.dart';
import 'todo_list.dart';

void main() {
  runApp(const TodoApp());
}

class TodoApp extends StatelessWidget {
  const TodoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Tvinga ljust tema för att undvika påverkan från enhetens inställningar
      theme: ThemeData.light(),
      home: const TodoList(),
    );
  }
}
