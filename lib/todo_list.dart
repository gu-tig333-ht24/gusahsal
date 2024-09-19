import 'package:flutter/material.dart';
import 'todo_item.dart'; // Import för TodoItem-modellen

class TodoList extends StatefulWidget {
  @override
  _TodoListState createState() => _TodoListState();
}

class _TodoListState extends State<TodoList> {
  List<TodoItem> _todos = [
    TodoItem(task: 'Write a book', isCompleted: false),
    TodoItem(task: 'Do homework', isCompleted: false),
    TodoItem(task: 'Tidy room', isCompleted: true),
    TodoItem(task: 'Watch TV', isCompleted: false),
    TodoItem(task: 'Nap', isCompleted: false),
    TodoItem(task: 'Shop groceries', isCompleted: false),
    TodoItem(task: 'Have fun', isCompleted: false),
    TodoItem(task: 'Meditate', isCompleted: false),
  ];

  void _addTodoItem(String task) {
    setState(() {
      _todos.add(TodoItem(task: task, isCompleted: false));
    });
  }

  void _toggleCompletion(int index) {
    setState(() {
      _todos[index].isCompleted = !_todos[index].isCompleted;
    });
  }

  void _removeTodoItem(int index) {
    setState(() {
      _todos.removeAt(index);
    });
  }

  void _showAddTodoDialog() {
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
                  _addTodoItem(controller.text);
                }
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'TIG333 TODO',
          style: TextStyle(color: Colors.grey),
        ),
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.grey),
      ),
      body: ListView.builder(
        itemCount: _todos.length,
        itemBuilder: (context, index) {
          return _todoItem(_todos[index], index);
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddTodoDialog,
        child: Icon(Icons.add),
      ),
    );
  }

  Widget _todoItem(TodoItem todo, int index) {
    return ListTile(
      leading: IconButton(
        icon: Icon(
            todo.isCompleted ? Icons.check_box : Icons.check_box_outline_blank),
        onPressed: () {
          _toggleCompletion(index);
        },
      ),
      title: Text(
        todo.task,
        style: TextStyle(
          decoration: todo.isCompleted
              ? TextDecoration.lineThrough
              : TextDecoration.none,
        ),
      ),
      trailing: IconButton(
        icon: Icon(Icons.close),
        onPressed: () {
          _removeTodoItem(index);
        },
      ),
    );
  }
}
