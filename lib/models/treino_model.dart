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
class PesosTreino {
  final int? id;
  final DateTime createdAt;
  final Treino treino;
  final int? peso;
  final int userId;

  PesosTreino({
    this.id,
    required this.createdAt,
    required this.treino,
    this.peso,
    required this.userId,
  });

  factory PesosTreino.fromMap(Map<String, dynamic> map, Treino treino) {
    return PesosTreino(
      id: map['id'],
      createdAt: DateTime.parse(map['createdAt']),
      treino: treino,
      peso: map['peso'],
      userId: map['userId'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'createdAt': createdAt.toIso8601String(),
      'treinoId': treino.id,
      'peso': peso,
      'userId': userId,
    };
  }
}

class PacoteTreino {
  final int? id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String nomePacote;
  final String letraDivisao;
  final String tipoTreino;
  final List<Treino> treinos;

  PacoteTreino({
    this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.nomePacote,
    required this.letraDivisao,
    required this.tipoTreino,
    required this.treinos,
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

  static PacoteTreino fromMap(Map<String, dynamic> map, List<Treino> treinos) {
    return PacoteTreino(
      id: map['id'],
      createdAt: DateTime.parse(map['createdAt']),
      updatedAt: DateTime.parse(map['updatedAt']),
      nomePacote: map['nomePacote'],
      letraDivisao: map['letraDivisao'],
      tipoTreino: map['tipoTreino'],
      treinos: treinos,
    );
  }
}

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

  static UserPacoteTreino fromMap(Map<String, dynamic> map, PacoteTreino pacoteTreino) {
    return UserPacoteTreino(
      id: map['id'],
      createdAt: DateTime.parse(map['createdAt']),
      updatedAt: DateTime.parse(map['updatedAt']),
      valido: map['valido'] == 1,
      pacoteTreino: pacoteTreino,
      userTreinadorId: map['userTreinadorId'],
      userAlunoId: map['userAlunoId'],
    );
  }
}

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

  static HistoricoTreino fromMap(Map<String, dynamic> map, UserPacoteTreino userPacoteTreino) {
    return HistoricoTreino(
      id: map['id'],
      createdAt: DateTime.parse(map['createdAt']),
      tempoTreino: map['tempoTreino'],
      userPacoteTreino: userPacoteTreino,
    );
  }
}
