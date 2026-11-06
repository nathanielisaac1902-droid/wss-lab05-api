class PostModel {
  final int userId;
  final int id;
  final String title;
  final String body;

  PostModel({
    required this.userId,
    required this.id,
    required this.title,
    required this.body,
  });

  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      userId: int.tryParse(json['userId']?.toString() ?? '') ?? 0,
      id: int.tryParse(json['id']?.toString() ?? '') ?? 0,
      title: json['title']?.toString() ?? '',
      body: json['body']?.toString() ?? '',
    );
  }
}