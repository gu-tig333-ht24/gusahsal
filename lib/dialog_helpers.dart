import 'package:flutter/material.dart';

void showAddTodoDialog(BuildContext context, Function(String) addTodo) {
  TextEditingController controller = TextEditingController();

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Add Todo'),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(hintText: 'Enter task here'),
        ),
        actions: [
          TextButton(
            child: Text('Cancel'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: Text('Add'),
            onPressed: () {
              if (controller.text.isNotEmpty) {
                addTodo(controller.text);
              }
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
