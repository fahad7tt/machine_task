import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/post_model.dart';

class PostsRepository {
  static const String baseUrl = 'https://jsonplaceholder.typicode.com';
  static const int postsPerPage = 20;
  static const String cacheKey = 'cached_posts';

  Future<List<Post>> fetchPosts(int page) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/posts?_page=$page&_limit=$postsPerPage'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        final posts = jsonData.map((json) => Post.fromJson(json)).toList();
        
        // Cache the first page
        if (page == 1) {
          await _cachePosts(posts);
        }
        
        return posts;
      } else {
        // Try to load from cache on error
        return await _getCachedPosts();
      }
    } catch (e) {
      // Network error, try cache
      final cachedPosts = await _getCachedPosts();
      if (cachedPosts.isNotEmpty) {
        return cachedPosts;
      }
      throw Exception('Network error: $e');
    }
  }

  Future<void> _cachePosts(List<Post> posts) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final postsJson = posts.map((post) => post.toJson()).toList();
      await prefs.setString(cacheKey, json.encode(postsJson));
    } catch (e) {
      // Ignore cache errors
    }
  }

  Future<List<Post>> _getCachedPosts() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cachedData = prefs.getString(cacheKey);
      
      if (cachedData != null) {
        final List<dynamic> jsonData = json.decode(cachedData);
        return jsonData.map((json) => Post.fromJson(json)).toList();
      }
    } catch (e) {
      // Ignore cache errors
    }
    
    return [];
  }
}