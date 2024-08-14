class Mural {
  final int? id;
  final String content;
  final String? image;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int userId;

  Mural({
    this.id,
    required this.content,
    this.image,
    required this.createdAt,
    required this.updatedAt,
    required this.userId,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'content': content,
      'imageUrl': image,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'userId': userId,
    };
  }

  factory Mural.fromJson(Map<String, dynamic> json) {
    return Mural(
      id: json['id'] as int?,
      content: json['content'] as String,
      image: json['imageUrl'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      userId: json['userId'] as int,
    );
  }
}
