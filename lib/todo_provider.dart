import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'todo_item.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TodoProvider extends ChangeNotifier {
  List<TodoItem> _todos = [];
  List<TodoItem> get todos => _filteredTodos();
  final String apiUrl = 'https://todoapp-api.apps.k8s.gu.se/todos';
  String? apiKey;
  String _filter = 'All'; // 'All', 'Completed', 'Incomplete'

  TodoProvider() {
    _loadApiKey();
  }

  void setFilter(String filter) {
    _filter = filter;
    notifyListeners();
  }

  List<TodoItem> _filteredTodos() {
    if (_filter == 'Completed') {
      return _todos.where((todo) => todo.isCompleted).toList();
    } else if (_filter == 'Incomplete') {
      return _todos.where((todo) => !todo.isCompleted).toList();
    }
    return _todos;
  }

  Future<void> _loadApiKey() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? storedKey = prefs.getString('api_key');
    if (storedKey == null) {
      await _registerAndSaveKey();
    } else {
      apiKey = storedKey;
      await fetchTodos();
    }
  }

  Future<void> _registerAndSaveKey() async {
    final response = await http
        .get(Uri.parse('https://todoapp-api.apps.k8s.gu.se/register'));
    if (response.statusCode == 200) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String key = response.body;
      await prefs.setString('api_key', key);
      apiKey = key;
      await fetchTodos();
    }
  }

  Future<void> fetchTodos() async {
    if (apiKey == null) return;
    final response = await http.get(Uri.parse('$apiUrl?key=$apiKey'));
    if (response.statusCode == 200) {
      final List<dynamic> todoJson = jsonDecode(response.body);
      _todos = todoJson.map((json) => TodoItem.fromJson(json)).toList();
      notifyListeners();
    }
  }

  Future<void> addTodoItem(String task) async {
    if (apiKey == null || task.isEmpty) return;
    final response = await http.post(
      Uri.parse('$apiUrl?key=$apiKey'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'title': task}),
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      await fetchTodos();
    }
  }

  Future<void> toggleCompletion(TodoItem todo, int index) async {
    if (apiKey == null) return;
    final response = await http.put(
      Uri.parse('$apiUrl/${todo.id}?key=$apiKey'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'title': todo.task, 'done': !todo.isCompleted}),
    );
    if (response.statusCode == 200 || response.statusCode == 204) {
      _todos[index].isCompleted = !_todos[index].isCompleted;
      notifyListeners();
    }
  }

  Future<void> removeTodoItem(int index) async {
    if (apiKey == null) return;
    final response = await http.delete(
      Uri.parse('$apiUrl/${_todos[index].id}?key=$apiKey'),
    );
    if (response.statusCode == 200 || response.statusCode == 204) {
      _todos.removeAt(index);
      notifyListeners();
    }
  }
}
