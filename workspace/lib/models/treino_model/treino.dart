class Treino {
  final int? id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String nome;
  final int qtdSeries;
  final String qtdRepeticoes;

  Treino({
    this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.nome,
    required this.qtdSeries,
    required this.qtdRepeticoes,
  });

  factory Treino.fromMap(Map<String, dynamic> map) {
    return Treino(
      id: map['id'],
      createdAt: DateTime.parse(map['createdAt']),
      updatedAt: DateTime.parse(map['updatedAt']),
      nome: map['nome'],
      qtdSeries: map['qtdSeries'],
      qtdRepeticoes: map['qtdRepeticoes'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'nome': nome,
      'qtdSeries': qtdSeries,
      'qtdRepeticoes': qtdRepeticoes,
    };
  }
}
