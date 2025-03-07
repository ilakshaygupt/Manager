import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/presentation/blocs/post_service/post_bloc.dart';
import 'package:task_manager/presentation/blocs/post_service/post_event.dart';
import 'package:task_manager/presentation/blocs/post_service/post_state.dart';
import 'package:task_manager/presentation/screens/post_card.dart';

class PostsList extends StatelessWidget {
  const PostsList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PostBloc, PostState>(
      builder: (context, state) {
        if (state is PostsLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is PostError) {
          return Center(
            child: Text(
              "Error: ${state.message}",
              style: const TextStyle(color: Colors.red),
            ),
          );
        } else if (state is PostsLoaded) {
          return RefreshIndicator(
            onRefresh: () async {
              context.read<PostBloc>().add(FetchPosts()); 
            },
            child: ListView.builder(
              itemCount: state.posts.length,
              padding: const EdgeInsets.all(8),
              itemBuilder: (context, index) {
                final post = state.posts[index];
                return PostCard(post: post, index: index);
              },
            ),
          );
        } else {
          return const Center(child: Text("No posts available"));
        }
      },
    );
  }
}
