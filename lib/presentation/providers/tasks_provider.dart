import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_manager/domain/entities/task.dart';

final taskProvider = StateNotifierProvider<TaskNotifier, List<Task>>((ref) {
  return TaskNotifier();
});

class TaskNotifier extends StateNotifier<List<Task>> {
  TaskNotifier() : super([]) {
    _allTasks = [];
    loadTasks();
  }

  late List<Task> _allTasks;
  String _searchQuery = '';

  Future<void> loadTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final String? tasksJson = prefs.getString('tasks');
    if (tasksJson != null) {
      List<dynamic> decodedList = jsonDecode(tasksJson);
      _allTasks =
          decodedList.map((taskJson) => Task.fromJson(taskJson)).toList();
      state = [..._allTasks];
    }
  }

  void updateSearchQuery(String query) {
    _searchQuery = query;
    _filterTasks();
  }

  void _filterTasks() {
    if (_searchQuery.isEmpty) {
      state = [..._allTasks];
    } else {
      state = _allTasks.where((task) {
        return task.title.toLowerCase().contains(_searchQuery.toLowerCase());
      }).toList();
    }
  }

  Future<void> addTask(String title) async {
    if (title.isEmpty) return;

    final task = Task(title: title);
    _allTasks = [..._allTasks, task];
    _filterTasks();
    await _saveTasks();
  }

  Future<void> toggleTaskCompletion(String id, bool value) async {
    _allTasks = _allTasks.map((task) {
      if (task.id == id) {
        return Task(
          title: task.title,
          isCompleted: value,
        )..id = task.id;
      }
      return task;
    }).toList();
    _filterTasks();
    await _saveTasks();
  }

  Future<void> deleteTask(String id) async {
    _allTasks = _allTasks.where((task) => task.id != id).toList();
    _filterTasks();
    await _saveTasks();
  }

  Future<void> _saveTasks() async {
    final prefs = await SharedPreferences.getInstance();
    List<Map<String, dynamic>> tasksJson =
        _allTasks.map((task) => task.toJson()).toList();
    await prefs.setString('tasks', jsonEncode(tasksJson));
  }
}
