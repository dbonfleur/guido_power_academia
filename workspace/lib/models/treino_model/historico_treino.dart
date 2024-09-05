class HistoricoTreino {
  final int? id;
  final DateTime createdAt;
  final String tempoTreino;
  final int pacoteTreinoId;
  final int alunoId;

  HistoricoTreino({
    this.id,
    required this.createdAt,
    required this.tempoTreino,
    required this.pacoteTreinoId,
    required this.alunoId,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'createdAt': createdAt.toIso8601String(),
      'tempoTreino': tempoTreino,
      'pacoteTreinoId': pacoteTreinoId,
      'alunoId': alunoId,
    };
  }

  factory HistoricoTreino.fromMap(Map<String, dynamic> map) {
    return HistoricoTreino(
      id: map['id'],
      createdAt: DateTime.parse(map['createdAt']),
      tempoTreino: map['tempoTreino'],
      pacoteTreinoId: map['pacoteTreinoId'],
      alunoId: map['alunoId'],
    );
  }
}
