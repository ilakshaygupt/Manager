import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:task_manager/domain/entities/post.dart';
import 'package:task_manager/presentation/screens/post_card.dart';

import '../providers/posts_provider.dart';

class PostsList extends ConsumerWidget {
  final List<Post> posts;

  const PostsList({required this.posts, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return RefreshIndicator(
      onRefresh: () => ref.read(postsProvider.notifier).refresh(),
      child: ListView.builder(
        itemCount: posts.length,
        padding: const EdgeInsets.all(8),
        itemBuilder: (context, index) {
          final post = posts[index];
          return PostCard(
            post: post,
            index: index,
          );
        },
      ),
    );
  }
}
