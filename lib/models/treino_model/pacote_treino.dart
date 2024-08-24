import 'treino.dart';

class PacoteTreino {
  final int? id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int? pacoteId;
  final List<Treino> treinos;

  PacoteTreino({
    this.id,
    required this.createdAt,
    required this.updatedAt,
    this.pacoteId,
    this.treinos = const [],
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'pacoteId': pacoteId,
      'treinos': treinos.map((e) => e.id).toList(),
    };
  }

  factory PacoteTreino.fromMap(Map<String, dynamic> map) {
    return PacoteTreino(
      id: map['id'],
      createdAt: DateTime.parse(map['createdAt']),
      updatedAt: DateTime.parse(map['updatedAt']),
      pacoteId: map['pacoteId'],
      treinos: List<Treino>.from(map['treinos']),
    );
  }
}
