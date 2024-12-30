import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:task_manager/presentation/screens/error_view.dart';
import 'package:task_manager/presentation/screens/loading_view.dart';
import 'package:task_manager/presentation/screens/post_lists.dart';

import '../providers/posts_provider.dart';
class PostsScreen extends ConsumerStatefulWidget {
  const PostsScreen({super.key});

  @override
  _PostsScreenState createState() => _PostsScreenState();
}

class _PostsScreenState extends ConsumerState<PostsScreen> {
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged() {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      final userIdText = _searchController.text;
      if (userIdText.isEmpty) {
        ref.read(postsProvider.notifier).refresh();
      } else {
        final userId = int.tryParse(userIdText);
        if (userId != null) {
          ref.read(postsProvider.notifier).getPostsByUserId(userId);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final postsAsync = ref.watch(postsProvider);
    final theme = Theme.of(context);

    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: theme.colorScheme.surfaceVariant.withOpacity(0.1),
              ),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search by User ID',
                  prefixIcon: Icon(
                    Icons.search,
                    color: theme.colorScheme.primary.withOpacity(0.7),
                  ),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      _searchController.clear();
                      ref.read(postsProvider.notifier).refresh();
                    },
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
                keyboardType: TextInputType.number,
              ),
            ),
          ),
          Expanded(
            child: postsAsync.when(
              loading: () => const LoadingView(),
              error: (error, stack) => ErrorView(
                error: error,
                onRetry: () => ref.read(postsProvider.notifier).refresh(),
              ),
              data: (posts) => PostsList(posts: posts),
            ),
          ),
        ],
      ),
    );
  }
}
