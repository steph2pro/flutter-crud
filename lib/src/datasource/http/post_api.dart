// lib/src/datasource/http/post_api.dart

import 'package:dio/dio.dart';
import '../models/post_model.dart';

class PostApi {
  final Dio dio;

  PostApi({required this.dio});

  // Fetch all posts
  Future<List<Post>> getPosts() async {
    final response = await dio.get('/posts');
    List<dynamic> data = response.data;
    return data.map((json) => Post.fromJson(json)).toList();
  }

  // Create a new post
  Future<Post> createPost(Post post) async {
    final response = await dio.post('https://jsonplaceholder.typicode.com/posts',
        data: post.toJson());
    return Post.fromJson(response.data);
  }

  // Update a post
  Future<Post> updatePost(int id, Post post) async {
    final response = await dio.put('https://jsonplaceholder.typicode.com/posts/$id',
        data: post.toJson());
    return Post.fromJson(response.data);
  }

  // Delete a post
  Future<void> deletePost(int id) async {
    await dio.delete('https://jsonplaceholder.typicode.com/posts/$id');
  }
  // Fetch a post by ID
  Future<Post> getPostById(int id) async {
    final response = await dio.get('https://jsonplaceholder.typicode.com/posts/$id');
    return Post.fromJson(response.data); // Conversion de la réponse en modèle Post
  }
}
