import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'todo_provider.dart';
import 'add_todo_page.dart';

class TodoList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('TIG333 TODO'),
        actions: [
          DropdownButton<String>(
            value: context.watch<TodoProvider>().filter,
            items: ['All', 'Completed', 'Incomplete'].map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: (value) {
              if (value != null) {
                context.read<TodoProvider>().setFilter(value);
              }
            },
          ),
        ],
      ),
      body: Consumer<TodoProvider>(
        builder: (context, todoProvider, child) {
          if (todoProvider.todos.isEmpty) {
            return Center(child: Text('Ingen todo att visa'));
          }
          return ListView.builder(
            itemCount: todoProvider.todos.length,
            itemBuilder: (context, index) {
              final todo = todoProvider.todos[index];
              return ListTile(
                leading: IconButton(
                  icon: Icon(
                    todo.isCompleted
                        ? Icons.check_box
                        : Icons.check_box_outline_blank,
                  ),
                  onPressed: () {
                    todoProvider.toggleCompletion(todo, index);
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
                    todoProvider.removeTodoItem(index);
                  },
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddTodoPage()),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
