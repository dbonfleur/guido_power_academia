class UserPacoteTreino {
  final int? id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool valido;
  final int pacoteId;
  final int treinadorId;
  final int alunoId;

  UserPacoteTreino({
    this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.valido,
    required this.pacoteId,
    required this.treinadorId,
    required this.alunoId,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'valido': valido ? 1 : 0,
      'pacoteId': pacoteId,
      'treinadorId': treinadorId,
      'alunoId': alunoId,
    };
  }

  factory UserPacoteTreino.fromMap(Map<String, dynamic> map) {
    return UserPacoteTreino(
      id: map['id'],
      createdAt: DateTime.parse(map['createdAt']),
      updatedAt: DateTime.parse(map['updatedAt']),
      valido: map['valido'] == 1,
      pacoteId: map['pacoteId'],
      treinadorId: map['treinadorId'],
      alunoId: map['alunoId'],
    );
  }
}
