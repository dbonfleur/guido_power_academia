import 'user_pacote_treino.dart';

class HistoricoTreino {
  final int? id;
  final DateTime createdAt;
  final String tempoTreino;
  final UserPacoteTreino userPacoteTreino;

  HistoricoTreino({
    this.id,
    required this.createdAt,
    required this.tempoTreino,
    required this.userPacoteTreino,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'createdAt': createdAt.toIso8601String(),
      'tempoTreino': tempoTreino,
      'userPacoteTreinoId': userPacoteTreino.id,
    };
  }

  factory HistoricoTreino.fromMap(Map<String, dynamic> map) {
    return HistoricoTreino(
      id: map['id'],
      createdAt: DateTime.parse(map['createdAt']),
      tempoTreino: map['tempoTreino'],
      userPacoteTreino: UserPacoteTreino.fromMap(map),
    );
  }
}
