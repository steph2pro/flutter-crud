import 'package:dio/dio.dart';
import '../models/user_model.dart';

class RandomUserApi {
  final Dio dio;

  RandomUserApi({required this.dio});

  Future<List<UserModel>> fetchRandomUsers() async {
    try {
      // Utilise l'instance dio configurée passée au constructeur
      final response = await dio.get('/api/?results=20');

      if (response.statusCode == 200) {
        return (response.data['results'] as List)
            .map((json) => UserModel.fromJson(json))
            .toList();
      }
      throw Exception('Failed to load users');
    } catch (e) {
      throw Exception('Error fetching users: $e');
    }
  }
}
