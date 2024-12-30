import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:task_manager/presentation/providers/theme_provider.dart';
import 'package:task_manager/presentation/screens/posts_screen.dart';
import 'package:task_manager/presentation/screens/task_screen.dart';

class MainScreen extends ConsumerWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          scrolledUnderElevation: 2,
          title: const Text(
            'Task Manager',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Hero(
                tag: 'theme-toggle',
                child: Material(
                  color: Colors.transparent,
                  child: IconButton.filledTonal(
                    icon: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      child: Icon(
                        ref.watch(themeProvider) == ThemeMode.light
                            ? Icons.dark_mode
                            : Icons.light_mode,
                        key: ValueKey(ref.watch(themeProvider)),
                      ),
                    ),
                    onPressed: () =>
                        ref.read(themeProvider.notifier).toggleTheme(),
                  ),
                ),
              ),
            ),
          ],
          bottom: TabBar(
            tabs: const [
              Tab(
                icon: Icon(Icons.task_alt),
                text: 'Tasks',
              ),
              Tab(
                icon: Icon(Icons.article_outlined),
                text: 'Posts',
              ),
            ],
            indicatorSize: TabBarIndicatorSize.tab,
            dividerColor: Colors.transparent,
            labelStyle: const TextStyle(fontWeight: FontWeight.w600),
            indicatorWeight: 3,
          ),
        ),
        body: const TabBarView(
          children: [
            TaskScreen(),
            PostsScreen(),
          ],
        ),
      ),
    );
  }
}
