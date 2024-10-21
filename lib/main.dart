import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'todo_list.dart';
import 'todo_provider.dart';

void main() {
  runApp(TodoApp());
}

class TodoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => TodoProvider(),
      child: MaterialApp(
        theme: ThemeData.light(),
        home: TodoList(),
      ),
    );
  }
}
