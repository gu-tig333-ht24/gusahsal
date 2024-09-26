import 'package:flutter/material.dart';

void showAddTodoDialog(BuildContext context, Function(String) addTodo) {
  TextEditingController controller = TextEditingController();

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Lägg till Todo'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(hintText: 'Ange uppgift här'),
        ),
        actions: [
          TextButton(
            child: const Text('Avbryt'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: const Text('Lägg till'),
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
