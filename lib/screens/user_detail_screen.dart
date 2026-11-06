import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../models/post_model.dart';
import '../services/api_service.dart';
import '../utils/app_colors.dart';

class UserPostsScreen extends StatefulWidget {
  final UserModel user;

  const UserPostsScreen({Key? key, required this.user}) : super(key: key);

  @override
  State<UserPostsScreen> createState() => _UserPostsScreenState();
}

class _UserPostsScreenState extends State<UserPostsScreen> {
  final ApiService _apiService = ApiService();
  late Future<List<PostModel>> _futurePosts;

  @override
  void initState() {
    super.initState();
    _loadPosts();
  }

  void _loadPosts() {
    setState(() {
      _futurePosts = _apiService.fetchPostsByUser(widget.user.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('${widget.user.firstName}\'s Posts'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: FutureBuilder<List<PostModel>>(
        future: _futurePosts,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No posts found for this user.'));
          }

          final posts = snapshot.data!;
          return ListView.builder(
            itemCount: posts.length,
            itemBuilder: (context, index) {
              final post = posts[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                elevation: 1,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        post.title,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.primary),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        post.body,
                        style: TextStyle(color: Colors.grey.shade700, fontSize: 14),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}