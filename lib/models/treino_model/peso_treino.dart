class PesosTreino {
  final int? id;
  final DateTime createdAt;
  final int treinoId;
  final int? peso;
  final int userId;

  PesosTreino({
    this.id,
    required this.createdAt,
    required this.treinoId,
    this.peso,
    required this.userId,
  });

  factory PesosTreino.fromMap(Map<String, dynamic> map) {
    return PesosTreino(
      id: map['id'],
      createdAt: DateTime.parse(map['createdAt']),
      treinoId: map['treinoId'],
      peso: map['peso'],
      userId: map['userId'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'createdAt': createdAt.toIso8601String(),
      'treinoId': treinoId,
      'peso': peso,
      'userId': userId,
    };
  }
}
