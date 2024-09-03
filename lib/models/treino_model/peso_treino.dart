class PesosTreino {
  final int? id;
  final DateTime createdAt;
  final int pacoteTreinoId;
  final int? peso;
  final int userId;

  PesosTreino({
    this.id,
    required this.createdAt,
    required this.pacoteTreinoId,
    this.peso,
    required this.userId,
  });

  factory PesosTreino.fromMap(Map<String, dynamic> map) {
    return PesosTreino(
      id: map['id'],
      createdAt: DateTime.parse(map['createdAt']),
      pacoteTreinoId: map['pacoteTreinoId'],
      peso: map['peso'],
      userId: map['userId'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'createdAt': createdAt.toIso8601String(),
      'pacoteTreinoId': pacoteTreinoId,
      'peso': peso,
      'userId': userId,
    };
  }
}
