

import 'package:task_manager/core/api/HTTPMethod.dart';
import 'package:task_manager/core/api/either.dart';

import '../../core/api/api_client.dart';
import '../models/post_model.dart';

class PostsRemoteDataSource {
  Future<Either<APIError, List<PostModel>>> getPosts() async {
    return APIRequest.call<void, List<PostModel>>(
      path: '/posts',
      method: HTTPMethod.get,
      fromJson: (data) =>
          (data as List).map((json) => PostModel.fromJson(json)).toList(),
    );
  }

  Future<Either<APIError, List<PostModel>>> getPostsByUserId(int userId) async {
    return APIRequest.call<void, List<PostModel>>(
      path: '/posts?userId=$userId',
      method: HTTPMethod.get,
      fromJson: (data) =>
          (data as List).map((json) => PostModel.fromJson(json)).toList(),
    );
  }

  Future<Either<APIError, PostModel>> createPost({
    required String title,
    required String body,
    required int userId,
  }) async {
    return APIRequest.call<Map<String, dynamic>, PostModel>(
      path: '/posts',
      method: HTTPMethod.post,
      parameters: {
        'title': title,
        'body': body,
        'userId': userId,
      },
      fromJson: (data) => PostModel.fromJson(data),
    );
  }
}
