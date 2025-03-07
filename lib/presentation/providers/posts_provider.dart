import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:task_manager/domain/repositories/i_posts_repository.dart';

import '../../data/datasources/posts_remote_datasource.dart';
import '../../data/repositories/posts_repository.dart';
import '../../domain/entities/post.dart';
import '../../domain/usecases/create_post.dart';
import '../../domain/usecases/get_posts.dart';

final postsRemoteDataSourceProvider = Provider<PostsRemoteDataSource>((ref) {
  return PostsRemoteDataSource();
});

final postsRepositoryProvider = Provider<IPostsRepository>((ref) {
  final remoteDataSource = ref.watch(postsRemoteDataSourceProvider);
  return PostsRepository(remoteDataSource);
});

final getPostsUseCaseProvider = Provider<GetPosts>((ref) {
  final repository = ref.watch(postsRepositoryProvider);
  return GetPosts(repository);
});

final getPostsByUserIdUseCaseProvider = Provider<GetPostsByUserId>((ref) {
  final repository = ref.watch(postsRepositoryProvider);
  return GetPostsByUserId(repository);
});

final createPostUseCaseProvider = Provider<CreatePost>((ref) {
  final repository = ref.watch(postsRepositoryProvider);
  return CreatePost(repository);
});

class PostsNotifier extends AsyncNotifier<List<Post>> {
  @override
  Future<List<Post>> build() async {
    return _fetchPosts();
  }

  Future<List<Post>> _fetchPosts() async {
    final getPostsUseCase = ref.read(getPostsUseCaseProvider);
    final result = await getPostsUseCase();

    return result.fold(
      (error) {
        state =
            AsyncError(error, StackTrace.current); 
        return [];
      },
      (posts) => posts,
    );
  }

  Future<void> getPostsByUserId(int userId) async {
    state = const AsyncLoading();

    final getPostsByUserIdUseCase = ref.read(getPostsByUserIdUseCaseProvider);
    final result = await getPostsByUserIdUseCase(userId);

    state = result.fold(
      (error) => AsyncError(error, StackTrace.current),
      (posts) => AsyncData(posts),
    );
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = AsyncData(await _fetchPosts());
  }

  Future<void> createPost(int userId, String title, String body) async {
    state = const AsyncLoading();

    final createPostUseCase = ref.read(createPostUseCaseProvider);
    final result = await createPostUseCase(userId, title, body);

    state = await result.fold(
      (error) => AsyncError(error, StackTrace.current),
      (newPost) async {
        final currentPosts = state.value ?? [];
        return AsyncData([newPost, ...currentPosts]);
      },
    );
  }
}

final postsProvider = AsyncNotifierProvider<PostsNotifier, List<Post>>(() {
  return PostsNotifier();
});
