import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:task_manager/core/consts/api_consts.dart';
import 'package:task_manager/core/theme/app_theme.dart';
import 'package:task_manager/data/datasources/posts_remote_datasource.dart';
import 'package:task_manager/data/repositories/posts_repository.dart';
import 'package:task_manager/domain/usecases/get_posts.dart';
import 'package:task_manager/presentation/blocs/post_service/post_bloc.dart';
import 'package:task_manager/presentation/blocs/tasks_service/task_bloc.dart';
import 'package:task_manager/presentation/blocs/tasks_service/task_event.dart';
import 'package:task_manager/presentation/providers/theme_provider.dart';
import 'package:task_manager/presentation/screens/main_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await loadEnv();
  final postsRepository = PostsRepository(PostsRemoteDataSource());

  runApp(
    ProviderScope(
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
              create: (context) => PostBloc(
                    getPosts: GetPosts(postsRepository),
                    getPostsByUserId: GetPostsByUserId(postsRepository),
                  )),
          BlocProvider(
            create: (context) => TaskBloc()..add(LoadTasks()),
          ),
        ],
        child: const MyApp(),
      ),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Task Manager',
      themeMode: themeMode,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      home: const MainScreen(),
    );
  }
}
