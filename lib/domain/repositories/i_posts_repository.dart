
import 'package:task_manager/core/api/api_client.dart';

import '../../core/api/either.dart';
import '../entities/post.dart';

abstract class IPostsRepository {
  Future<Either<APIError, List<Post>>> getPosts();
  Future<Either<APIError, List<Post>>> getPostsByUserId(int userId);
  Future<Either<APIError, Post>> createPost(
      int userId, String title, String body);
}
