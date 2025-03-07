import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/presentation/blocs/post_service/post_bloc.dart';
import 'package:task_manager/presentation/blocs/post_service/post_event.dart';
import 'package:task_manager/presentation/blocs/post_service/post_state.dart';
import 'package:task_manager/presentation/screens/error_view.dart';
import 'package:task_manager/presentation/screens/loading_view.dart';
import 'package:task_manager/presentation/screens/post_lists.dart';

class PostsScreen extends StatefulWidget {
  const PostsScreen({super.key});

  @override
  State<PostsScreen> createState() => _PostsScreenState();
}

class _PostsScreenState extends State<PostsScreen> {
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
    context.read<PostBloc>().add(FetchPosts());
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
        context.read<PostBloc>().add(FetchPosts());
      } else {
        final userId = int.tryParse(userIdText);
        if (userId != null) {
          context.read<PostBloc>().add(FetchPostsByUserId(userId));
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
              ),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search by User ID',
                  prefixIcon: Icon(
                    Icons.search,
                  ),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      _searchController.clear();
                      context.read<PostBloc>().add(FetchPosts());
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
            child: BlocBuilder<PostBloc, PostState>(
              builder: (context, state) {
                if (state is PostsLoading) {
                  return const LoadingView();
                } else if (state is PostsLoaded) {
                  return PostsList();
                } else if (state is PostError) {
                  return ErrorView(
                    error: state.message,
                    onRetry: () => context.read<PostBloc>().add(FetchPosts()),
                  );
                }
                return const Center(child: Text('Something went wrong'));
              },
            ),
          ),
        ],
      ),
    );
  }
}
