// lib/src/features/post/post_event.dart

import 'package:equatable/equatable.dart';
import '../../../datasource/models/post_model.dart';

abstract class PostEvent extends Equatable {
  const PostEvent();

  @override
  List<Object> get props => [];
}

class FetchPosts extends PostEvent {}

class CreatePost extends PostEvent {
  final Post post;

  const CreatePost(this.post);

  @override
  List<Object> get props => [post];
}

class UpdatePost extends PostEvent {
  final int id;
  final Post post;

  const UpdatePost(this.id, this.post);

  @override
  List<Object> get props => [id, post];
}

class DeletePost extends PostEvent {
  final int id;

  const DeletePost(this.id);

  @override
  List<Object> get props => [id];
}

// Ajoute le nouvel événement FetchPostById
class FetchPostById extends PostEvent {
  final int id;

  FetchPostById(this.id);
}