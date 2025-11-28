import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repositories/posts_repository.dart';
import 'posts_event.dart';
import 'posts_state.dart';

class PostsBloc extends Bloc<PostsEvent, PostsState> {
  final PostsRepository repository;
  int _currentPage = 1;
  bool _isLoadingMore = false;

  PostsBloc(this.repository) : super(PostsInitial()) {
    on<LoadInitialPosts>(_onLoadInitialPosts);
    on<LoadMorePosts>(_onLoadMorePosts);
    on<RefreshPosts>(_onRefreshPosts);
  }

  Future<void> _onLoadInitialPosts(
    LoadInitialPosts event,
    Emitter<PostsState> emit,
  ) async {
    emit(PostsLoading());
    try {
      _currentPage = 1;
      final posts = await repository.fetchPosts(_currentPage);
      emit(PostsLoaded(
        posts: posts,
        hasMore: posts.length == PostsRepository.postsPerPage,
      ));
    } catch (e) {
      emit(PostsError(e.toString()));
    }
  }

  Future<void> _onLoadMorePosts(
    LoadMorePosts event,
    Emitter<PostsState> emit,
  ) async {
    if (_isLoadingMore) return;

    final currentState = state;
    if (currentState is! PostsLoaded || !currentState.hasMore) return;

    _isLoadingMore = true;

    try {
      _currentPage++;
      final newPosts = await repository.fetchPosts(_currentPage);
      
      emit(currentState.copyWith(
        posts: [...currentState.posts, ...newPosts],
        hasMore: newPosts.length == PostsRepository.postsPerPage,
      ));
    } catch (e) {
      emit(PostsError(e.toString()));
    } finally {
      _isLoadingMore = false;
    }
  }

  Future<void> _onRefreshPosts(
    RefreshPosts event,
    Emitter<PostsState> emit,
  ) async {
    try {
      _currentPage = 1;
      final posts = await repository.fetchPosts(_currentPage);
      emit(PostsLoaded(
        posts: posts,
        hasMore: posts.length == PostsRepository.postsPerPage,
      ));
    } catch (e) {
      emit(PostsError(e.toString()));
    }
  }
}