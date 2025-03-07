import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_manager/domain/entities/task.dart';
import 'package:task_manager/presentation/blocs/tasks_service/task_event.dart';
import 'package:task_manager/presentation/blocs/tasks_service/task_state.dart';
import 'package:uuid/uuid.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  TaskBloc()
      : super(const TaskLoaded(
            allTasks: [], filteredTasks: [], searchQuery: '')) {
    on<LoadTasks>(_onLoadTasks);
    on<AddTask>(_onAddTask);
    on<ToggleTaskCompletion>(_onToggleTaskCompletion);
    on<DeleteTask>(_onDeleteTask);
    on<UpdateSearchQuery>(_onUpdateSearchQuery);
  }
  Future<void> _onLoadTasks(LoadTasks event, Emitter<TaskState> emit) async {
    emit(TaskLoading());
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? tasksJson = prefs.getString('tasks');

      final List<Task> allTasks = tasksJson != null
          ? (jsonDecode(tasksJson)
                  as List) 
              .map((taskMap) =>
                  Task.fromJson(taskMap)) 
              .toList()
          : [];

      emit(TaskLoaded(
          allTasks: allTasks, filteredTasks: allTasks, searchQuery: ''));
    } catch (e) {
      emit(TaskError('Failed to load tasks'));
    }
  }

  Future<void> _onAddTask(AddTask event, Emitter<TaskState> emit) async {
    if (state is TaskLoaded) {
      final currentState = state as TaskLoaded;
      final newTask =
          Task(id: const Uuid().v4(), title: event.title, isCompleted: false);
      final updatedTasks = List<Task>.from(currentState.allTasks)..add(newTask);
      await _saveTasks(updatedTasks);
      emit(currentState.copyWith(allTasks: updatedTasks));
      _filterTasks(emit, updatedTasks, currentState.searchQuery);
    }
  }

  Future<void> _onToggleTaskCompletion(
      ToggleTaskCompletion event, Emitter<TaskState> emit) async {
    if (state is TaskLoaded) {
      final currentState = state as TaskLoaded;
      final updatedTasks = currentState.allTasks.map((task) {
        return task.id == event.id
            ? task.copyWith(isCompleted: event.value)
            : task;
      }).toList();
      await _saveTasks(updatedTasks);
      emit(currentState.copyWith(allTasks: updatedTasks));
      _filterTasks(emit, updatedTasks, currentState.searchQuery);
    }
  }

  Future<void> _onDeleteTask(DeleteTask event, Emitter<TaskState> emit) async {
    if (state is TaskLoaded) {
      final currentState = state as TaskLoaded;
      final updatedTasks =
          currentState.allTasks.where((task) => task.id != event.id).toList();
      await _saveTasks(updatedTasks);
      emit(currentState.copyWith(allTasks: updatedTasks));
      _filterTasks(emit, updatedTasks, currentState.searchQuery);
    }
  }

  void _onUpdateSearchQuery(UpdateSearchQuery event, Emitter<TaskState> emit) {
    if (state is TaskLoaded) {
      final currentState = state as TaskLoaded;
      _filterTasks(emit, currentState.allTasks, event.query);
    }
  }

  void _filterTasks(
      Emitter<TaskState> emit, List<Task> allTasks, String query) {
    final filteredTasks = query.isEmpty
        ? allTasks
        : allTasks
            .where((task) =>
                task.title.toLowerCase().contains(query.toLowerCase()))
            .toList();
    emit(TaskLoaded(
        allTasks: allTasks, filteredTasks: filteredTasks, searchQuery: query));
  }

  Future<void> _saveTasks(List<Task> tasks) async {
    final prefs = await SharedPreferences.getInstance();
    final String encodedTasks =
        jsonEncode(tasks.map((task) => task.toJson()).toList());

    await prefs.setString('tasks', encodedTasks);
  }
}
