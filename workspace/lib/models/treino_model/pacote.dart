class Pacote {
  final int? id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String nomePacote;
  final String letraDivisao;
  final String tipoTreino;

  Pacote({
    this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.nomePacote,
    required this.letraDivisao,
    required this.tipoTreino,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'nomePacote': nomePacote,
      'letraDivisao': letraDivisao,
      'tipoTreino': tipoTreino,
    };
  }

  static Pacote fromMap(Map<String, dynamic> map) {
    return Pacote(
      id: map['id'],
      createdAt: DateTime.parse(map['createdAt']),
      updatedAt: DateTime.parse(map['updatedAt']),
      nomePacote: map['nomePacote'],
      letraDivisao: map['letraDivisao'],
      tipoTreino: map['tipoTreino'],
    );
  }
}
