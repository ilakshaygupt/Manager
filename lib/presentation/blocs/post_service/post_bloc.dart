import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/domain/usecases/get_posts.dart';

import 'post_event.dart';
import 'post_state.dart';

class PostBloc extends Bloc<PostEvent, PostState> {
  final GetPosts getPosts;
  final GetPostsByUserId getPostsByUserId;

  PostBloc({required this.getPosts, required this.getPostsByUserId})
      : super(PostsLoading()) {
    on<FetchPosts>(_onFetchPosts);
    on<FetchPostsByUserId>(_onFetchPostsByUserId);
  }

  Future<void> _onFetchPosts(FetchPosts event, Emitter<PostState> emit) async {
    emit(PostsLoading());

    final result = await getPosts();

    result.fold(
      (error) => emit(PostError(message: error.message)),
      (posts) => emit(PostsLoaded(posts: posts)),
    );
  }

  Future<void> _onFetchPostsByUserId(
    
      FetchPostsByUserId event, Emitter<PostState> emit) async {
    emit(PostsLoading());

    final result = await getPostsByUserId(event.userId);

    result.fold(
      (error) => emit(PostError(message: error.message)),
      (posts) => emit(PostsLoaded(posts: posts)),
    );
  }
}
