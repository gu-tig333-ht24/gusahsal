import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'todo_item.dart';
import 'dialog_helpers.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TodoList extends StatefulWidget {
  const TodoList({super.key});

  @override
  _TodoListState createState() => _TodoListState();
}

class _TodoListState extends State<TodoList> {
  List<TodoItem> _todos = [];
  final String apiUrl = 'https://todoapp-api.apps.k8s.gu.se/todos';
  String? apiKey;

  @override
  void initState() {
    super.initState();
    _loadApiKey();
  }

  // Ladda API-nyckel från SharedPreferences
  Future<void> _loadApiKey() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? storedKey = prefs.getString('api_key');
    if (storedKey == null) {
      await _registerAndSaveKey();
    } else {
      setState(() {
        apiKey = storedKey;
      });
      _fetchTodos();
    }
  }

  // Registrera och spara API-nyckel
  Future<void> _registerAndSaveKey() async {
    final response = await http
        .get(Uri.parse('https://todoapp-api.apps.k8s.gu.se/register'));
    if (response.statusCode == 200) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String key = response.body;
      await prefs.setString('api_key', key);
      setState(() {
        apiKey = key;
      });
      _fetchTodos();
    } else {
      _showErrorSnackbar('Misslyckades med att registrera API-nyckel');
    }
  }

  // Hämta Todo-items från API
  Future<void> _fetchTodos() async {
    if (apiKey == null) return;

    try {
      final response = await http.get(Uri.parse('$apiUrl?key=$apiKey'));
      if (response.statusCode == 200) {
        final List<dynamic> todoJson = jsonDecode(response.body);
        setState(() {
          _todos = todoJson.map((json) => TodoItem.fromJson(json)).toList();
        });
      } else {
        _showErrorSnackbar('Misslyckades med att ladda todo-listan');
      }
    } catch (e) {
      _showErrorSnackbar('Nätverksfel');
    }
  }

  // Lägg till en Todo-item
  void _addTodoItem(String task) async {
    if (apiKey == null) return;

    try {
      final response = await http.post(
        Uri.parse('$apiUrl?key=$apiKey'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'title': task, 'done': false}),
      );

      if (response.statusCode == 201) {
        _fetchTodos();
      } else {
        _showErrorSnackbar('Misslyckades med att lägga till todo');
      }
    } catch (e) {
      _showErrorSnackbar('Nätverksfel');
    }
  }

  // Växla mellan avklarad och ej avklarad
  void _toggleCompletion(TodoItem todo, int index) async {
    if (apiKey == null) return;

    try {
      final response = await http.put(
        Uri.parse('$apiUrl/${todo.id}?key=$apiKey'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'title': todo.task, 'done': !todo.isCompleted}),
      );

      if (response.statusCode == 200) {
        setState(() {
          _todos[index].isCompleted = !_todos[index].isCompleted;
        });
      } else {
        _showErrorSnackbar('Misslyckades med att uppdatera todo');
      }
    } catch (e) {
      _showErrorSnackbar('Nätverksfel');
    }
  }

  // Ta bort en Todo-item
  void _removeTodoItem(int index) async {
    if (apiKey == null) return;

    try {
      final response = await http.delete(
        Uri.parse('$apiUrl/${_todos[index].id}?key=$apiKey'),
      );

      if (response.statusCode == 200) {
        setState(() {
          _todos.removeAt(index);
        });
      } else {
        _showErrorSnackbar('Misslyckades med att ta bort todo');
      }
    } catch (e) {
      _showErrorSnackbar('Nätverksfel');
    }
  }

  // Visa dialog för att lägga till ny Todo
  void _showAddTodoDialog() {
    showAddTodoDialog(context, (task) => _addTodoItem(task));
  }

  // Visa felmeddelande
  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'TIG333 TODO',
          style: TextStyle(color: Colors.grey),
        ),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.grey),
      ),
      body: _buildTodoList(),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddTodoDialog,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildTodoList() {
    if (_todos.isEmpty) {
      return const Center(
        child: Text('Ingen todo att visa'),
      );
    } else {
      return ListView.builder(
        itemCount: _todos.length,
        itemBuilder: (context, index) {
          return _todoItem(_todos[index], index);
        },
      );
    }
  }

  Widget _todoItem(TodoItem todo, int index) {
    return ListTile(
      leading: IconButton(
        icon: Icon(
          todo.isCompleted ? Icons.check_box : Icons.check_box_outline_blank,
        ),
        onPressed: () {
          _toggleCompletion(todo, index);
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
        icon: const Icon(Icons.close),
        onPressed: () {
          _removeTodoItem(index);
        },
      ),
    );
  }
}
