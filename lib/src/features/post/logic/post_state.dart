// lib/src/features/post/post_state.dart

import 'package:equatable/equatable.dart';
import '../../../datasource/models/post_model.dart';
import '../../../datasource/models/api_response/api_response.dart';

abstract class PostState extends Equatable {
  const PostState();

  @override
  List<Object?> get props => [];
}

class PostInitial extends PostState {}

class PostLoading extends PostState {}

class PostLoaded extends PostState {
  final List<Post> posts;

  const PostLoaded({required this.posts});

  @override
  List<Object?> get props => [posts];
}

class PostError extends PostState {
  final ApiError error;

  const PostError({required this.error});

  @override
  List<Object?> get props => [error];
}

// Nouveaux états pour la mise à jour des posts
class PostUpdateSuccess extends PostState {}

class PostUpdateFailure extends PostState {
  final String message;

  const PostUpdateFailure({required this.message});

  @override
  List<Object?> get props => [message];
}
class PostLoadedById extends PostState { // Nouvel état pour un post spécifique
  final Post post;

  PostLoadedById({required this.post});
}
