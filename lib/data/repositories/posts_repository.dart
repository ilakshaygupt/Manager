

import 'package:task_manager/core/api/api_client.dart';

import '../../core/api/either.dart';
import '../../domain/entities/post.dart';
import '../../domain/repositories/i_posts_repository.dart';
import '../datasources/posts_remote_datasource.dart';

class PostsRepository implements IPostsRepository {
  final PostsRemoteDataSource _remoteDataSource;

  PostsRepository(this._remoteDataSource);

  @override
  Future<Either<APIError, List<Post>>> getPosts() async {
    return _remoteDataSource.getPosts();
  }

  @override
  Future<Either<APIError, List<Post>>> getPostsByUserId(int userId) async {
    return _remoteDataSource.getPostsByUserId(userId);
  }

  @override
  Future<Either<APIError, Post>> createPost(
    int userId,
    String title,
    String body,
  ) async {
    return _remoteDataSource.createPost(
      title: title,
      body: body,
      userId: userId,
    );
  }
}
