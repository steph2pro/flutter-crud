import 'package:flutter_kit/src/datasource/http/dio_config.dart';
import 'package:flutter_kit/src/datasource/http/post_api.dart';
import 'package:flutter_kit/src/datasource/models/api_response/api_response.dart';
import 'package:flutter_kit/src/datasource/repositories/base_repository.dart';
import 'package:flutter_kit/src/shared/locator.dart';
import '../models/post_model.dart';
// import '../models/api_response/api_error.dart';

class PostRepository extends BaseRepository {
  final PostApi postApi;

  PostRepository({
    PostApi? postApi,
  }) : postApi = postApi ?? PostApi(dio: locator<DioConfig>().dio);

  // Get list of posts
  Future<ApiResponse<List<Post>, ApiError>> getPosts() async {
    return runApiCall(
      call: () async {
        final response = await postApi.getPosts();
        return ApiResponse.success(response);
      },
    );
  }

  // Create a new post
  Future<ApiResponse<Post, ApiError>> createPost(Post post) async {
    return runApiCall(
      call: () async {
        final response = await postApi.createPost(post);
        return ApiResponse.success(response);
      },
    );
  }

  // Update an existing post
  Future<ApiResponse<Post, ApiError>> updatePost(int id, Post post) async {
    return runApiCall(
      call: () async {
        final response = await postApi.updatePost(id, post);
        return ApiResponse.success(response);
      },
    );
  }

  // Delete a post
  Future<ApiResponse<void, ApiError>> deletePost(int id) async {
    return runApiCall(
      call: () async {
        await postApi.deletePost(id);
        return ApiResponse.success(null);
      },
    );
  }
  // Get a post by ID
  Future<ApiResponse<Post, ApiError>> getPostById(int id) async {
    return runApiCall(
      call: () async {
        final response = await postApi.getPostById(id);
        return ApiResponse.success(response);
      },
    );
  }
}
