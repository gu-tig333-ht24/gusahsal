import 'package:flutter/material.dart';
import 'todo_list.dart';

void main() {
  runApp(const TodoApp());
}

class TodoApp extends StatelessWidget {
  const TodoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: TodoList(), // Use the TodoList from todo_list.dart
    );
  }
}








// // import 'package:flutter/material.dart';

// // void main() {
// //   runApp(TodoApp());
// // }

// // class TodoApp extends StatelessWidget {
// //   @override
// //   Widget build(BuildContext context) {
// //     return MaterialApp(
// //       home: TodoList(),
// //     );
// //   }
// // }

// // class TodoList extends StatelessWidget {
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: const Text(
// //           'TIG333 TODO',
// //           style: TextStyle(
// //             color: Colors.black, // Gör texten grå
// //           ),
// //         ),
// //         backgroundColor: Colors
// //             .grey, // Valfri, men för att se grå text bra kan bakgrunden vara vit
// //         iconTheme: const IconThemeData(
// //           color: Colors.grey, // Gör ikonerna grå också, om du har några
// //         ),
// //       ),
// //       body: Column(
// //         children: [
// //           _todoItem('Write a book'),
// //           _todoItem('Do homework'),
// //           _todoItemCompleted('Tidy room'),
// //           _todoItem('Watch TV'),
// //           _todoItem('Nap'),
// //           _todoItem('Shop groceries'),
// //           _todoItem('Have fun'),
// //           _todoItem('Meditate'),
// //         ],
// //       ),
// //       floatingActionButton: FloatingActionButton(
// //         onPressed: () {},
// //         child: const Icon(Icons.add),
// //       ),
// //     );
// //   }

// //   Widget _todoItem(String task) {
// //     return ListTile(
// //       leading: const Icon(Icons.check_box_outline_blank),
// //       title: Text(task),
// //       trailing: const Icon(Icons.close),
// //     );
// //   }

// //   Widget _todoItemCompleted(String task) {
// //     return ListTile(
// //       leading: const Icon(Icons.check_box),
// //       title: Text(
// //         task,
// //         style: const TextStyle(decoration: TextDecoration.lineThrough),
// //       ),
// //       trailing: const Icon(Icons.close),
// //     );
// //   }
// // }
