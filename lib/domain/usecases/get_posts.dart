import 'package:task_manager/core/api/api_client.dart';

import '../../core/api/either.dart';
import '../entities/post.dart';
import '../repositories/i_posts_repository.dart';

class GetPosts {
  final IPostsRepository repository;

  GetPosts(this.repository);

  Future<Either<APIError, List<Post>>> call() {
    return repository.getPosts();
  }
}

class GetPostsByUserId {
  final IPostsRepository repository;

  GetPostsByUserId(this.repository);

  Future<Either<APIError, List<Post>>> call(int userId) {
    return repository.getPostsByUserId(userId);
  }
}
