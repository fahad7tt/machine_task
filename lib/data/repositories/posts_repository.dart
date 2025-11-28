import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/post_model.dart';

class PostsRepository {
  static const String baseUrl = 'https://jsonplaceholder.typicode.com';
  static const int postsPerPage = 20;

  Future<List<Post>> fetchPosts(int page) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/posts?_page=$page&_limit=$postsPerPage'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        return jsonData.map((json) => Post.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load posts: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }
}