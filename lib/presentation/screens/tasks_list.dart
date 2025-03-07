import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/presentation/blocs/tasks_service/task_bloc.dart';
import 'package:task_manager/presentation/blocs/tasks_service/task_event.dart';
import 'package:task_manager/presentation/blocs/tasks_service/task_state.dart';

class TasksList extends StatelessWidget {
  const TasksList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TaskBloc, TaskState>(
      builder: (context, state) {
        if (state is TaskLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is TaskError) {
          return Center(child: Text('Error: ${state.message}'));
        } else if (state is TaskLoaded) {
          if (state.filteredTasks.isEmpty) {
            return const Center(child: Text('No tasks available'));
          }
          return ListView.builder(
            itemCount: state.filteredTasks.length,
            itemBuilder: (context, index) {
              final task = state.filteredTasks[index];
              return ListTile(
                title: Text(task.title),
                leading: Checkbox(
                  value: task.isCompleted,
                  onChanged: (value) {
                    if (value != null) {
                      context.read<TaskBloc>().add(
                            ToggleTaskCompletion(task.id, value),
                          );
                    }
                  },
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    context.read<TaskBloc>().add(DeleteTask(task.id));
                  },
                ),
              );
            },
          );
        }
        return const Center(child: Text('Something went wrong'));
      },
    );
  }
}
