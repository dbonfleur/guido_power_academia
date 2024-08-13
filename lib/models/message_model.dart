class Message {
  final int? id;
  final String content;
  final String? imageUrl;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int userId;

  Message({
    this.id,
    required this.content,
    this.imageUrl,
    required this.createdAt,
    required this.updatedAt,
    required this.userId,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'content': content,
      'imageUrl': imageUrl,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'userId': userId,
    };
  }

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['id'] as int?,
      content: json['content'] as String,
      imageUrl: json['imageUrl'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      userId: json['userId'] as int,
    );
  }
}
