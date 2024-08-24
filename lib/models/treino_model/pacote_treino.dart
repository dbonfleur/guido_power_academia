class PacoteTreino {
  final int? id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int pacoteId;
  final List<int> treinoIds;

  PacoteTreino({
    this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.pacoteId,
    required this.treinoIds,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'pacoteId': pacoteId,
      'treinoIds': treinoIds,
    };
  }

  factory PacoteTreino.fromMap(Map<String, dynamic> map) {
    return PacoteTreino(
      id: map['id'],
      createdAt: DateTime.parse(map['createdAt']),
      updatedAt: DateTime.parse(map['updatedAt']),
      pacoteId: map['pacoteId'],
      treinoIds: List<int>.from(map['treinoIds']),
    );
  }
}
