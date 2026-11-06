import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'package:http/http.dart' as http;
import '../models/user_model.dart';
import '../models/post_model.dart';
import '../utils/app_constants.dart';

class ApiService {
  // 1. Fetch Users with Pagination (ReqRes)
  Future<List<UserModel>> fetchUsers({int page = 1}) async {
    try {
      final url = Uri.parse('${AppConstants.reqResBaseUrl}/users?page=$page');
      final response = await http.get(url).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body)['data'] as List;
        return data.map((json) => UserModel.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load users: ${response.statusCode}');
      }
    } on SocketException {
      throw Exception('No Internet connection. Please check your network.');
    } on TimeoutException {
      throw Exception('Request timed out. Please try again.');
    }
  }

  // 2. Fetch Posts by User (JSONPlaceholder)
  Future<List<PostModel>> fetchPostsByUser(int userId) async {
    try {
      final url = Uri.parse('${AppConstants.jsonPlaceholderBaseUrl}/posts?userId=$userId');
      final response = await http.get(url).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final List data = jsonDecode(response.body);
        return data.map((json) => PostModel.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load posts: ${response.statusCode}');
      }
    } on SocketException {
      throw Exception('No Internet connection.');
    } on TimeoutException {
      throw Exception('Request timed out.');
    }
  }

  // 3. Create Post (JSONPlaceholder POST)
  Future<Map<String, dynamic>> createPost({
    required String title,
    required String body,
    required int userId,
  }) async {
    try {
      final url = Uri.parse('${AppConstants.jsonPlaceholderBaseUrl}/posts');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: jsonEncode({
          'title': title,
          'body': body,
          'userId': userId,
        }),
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 201) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to create post: ${response.statusCode}');
      }
    } on SocketException {
      throw Exception('No Internet connection.');
    } on TimeoutException {
      throw Exception('Request timed out.');
    }
  }
}