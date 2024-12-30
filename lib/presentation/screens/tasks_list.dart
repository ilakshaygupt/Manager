import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:task_manager/domain/entities/task.dart';
import 'package:task_manager/presentation/providers/tasks_provider.dart';

class TasksList extends ConsumerWidget {
  final List<Task> tasks;

  const TasksList({required this.tasks, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListView.builder(
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        final task = tasks[index];
        return ListTile(
          title: Text(task.title),
          leading: Checkbox(
            value: task.isCompleted,
            onChanged: (value) {
              ref
                  .read(taskProvider.notifier)
                  .toggleTaskCompletion(task.id, value!);
            },
          ),
          trailing: IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              ref.read(taskProvider.notifier).deleteTask(task.id);
            },
          ),
        );
      },
    );
  }
}
