import 'package:equatable/equatable.dart';
import '../../data/models/post_model.dart';

abstract class PostsState extends Equatable {
  const PostsState();

  @override
  List<Object> get props => [];
}

class PostsInitial extends PostsState {}

class PostsLoading extends PostsState {}

class PostsLoaded extends PostsState {
  final List<Post> posts;
  final bool hasMore;

  const PostsLoaded({
    required this.posts,
    required this.hasMore,
  });

  PostsLoaded copyWith({
    List<Post>? posts,
    bool? hasMore,
  }) {
    return PostsLoaded(
      posts: posts ?? this.posts,
      hasMore: hasMore ?? this.hasMore,
    );
  }

  @override
  List<Object> get props => [posts, hasMore];
}

class PostsError extends PostsState {
  final String message;

  const PostsError(this.message);

  @override
  List<Object> get props => [message];
}