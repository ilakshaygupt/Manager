import 'package:equatable/equatable.dart';

abstract class PostEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class FetchPosts extends PostEvent {}

class FetchPostsByUserId extends PostEvent {
  final int userId;

  FetchPostsByUserId(this.userId);

  @override
  List<Object> get props => [userId];
}
