
import 'package:task_manager/core/api/api_client.dart';

import '../repositories/i_posts_repository.dart';
import '../entities/post.dart';
import '../../core/api/either.dart';
class CreatePost {
  final IPostsRepository repository;

  CreatePost(this.repository);

  Future<Either<APIError, Post>> call(int userId, String title, String body) {
    return repository.createPost(userId, title, body);
  }
}