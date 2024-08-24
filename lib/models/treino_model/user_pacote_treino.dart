import 'pacote_treino.dart';

class UserPacoteTreino {
  final int? id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool valido;
  final PacoteTreino pacoteTreino;
  final int userTreinadorId;
  final int userAlunoId;

  UserPacoteTreino({
    this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.valido,
    required this.pacoteTreino,
    required this.userTreinadorId,
    required this.userAlunoId,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'valido': valido ? 1 : 0,
      'pacoteTreinoId': pacoteTreino.id,
      'userTreinadorId': userTreinadorId,
      'userAlunoId': userAlunoId,
    };
  }

  factory UserPacoteTreino.fromMap(Map<String, dynamic> map) {
    return UserPacoteTreino(
      id: map['id'],
      createdAt: DateTime.parse(map['createdAt']),
      updatedAt: DateTime.parse(map['updatedAt']),
      valido: map['valido'] == 1,
      pacoteTreino: PacoteTreino.fromMap(map),
      userTreinadorId: map['userTreinadorId'],
      userAlunoId: map['userAlunoId'],
    );
  }
}
