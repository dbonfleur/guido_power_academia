import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/authentication/authentication_bloc.dart';
import '../blocs/search/search_bloc.dart';
import '../blocs/search/search_state.dart';
import '../blocs/treino/pacote_bloc.dart';
import '../blocs/treino/pacote_event.dart';
import '../blocs/treino/pacote_state.dart';
import '../blocs/treino/user_pacote_treino_bloc.dart';
import '../blocs/treino/user_pacote_treino_event.dart';
import '../blocs/treino/user_pacote_treino_state.dart';
import '../models/treino_model/pacote.dart';
import '../models/treino_model/user_pacote_treino.dart';

class StudentScreen extends StatefulWidget {
  const StudentScreen({super.key});

  @override
  _StudentScreenState createState() => _StudentScreenState();
}

class _StudentScreenState extends State<StudentScreen> {
  int? userAlunoId;
  Map<String, bool> expandedState = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            BlocBuilder<SearchBloc, SearchState>(
              builder: (context, state) {
                if (state is SearchLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is SearchUsersLoaded) {
                  return DropdownButtonFormField(
                    decoration: const InputDecoration(
                      labelText: 'Selecione um aluno',
                      border: OutlineInputBorder(),
                    ),
                    items: state.users.map((user) {
                      return DropdownMenuItem(
                        value: user.id,
                        child: Row(
                          children: [
                            CircleAvatar(
                              backgroundImage: MemoryImage(base64Decode(user.imageUrl)),
                              radius: 20,
                            ),
                            const SizedBox(width: 8.0),
                            Text(user.fullName),
                          ],
                        ),
                      );
                    }).toList(),
                    onChanged: (id) {
                      setState(() {
                        userAlunoId = id as int?;
                      });
                      context.read<UserPacoteTreinoBloc>().add(LoadUserPacotesTreino(id as int));
                      context.read<PacoteBloc>().add(LoadPacotes());
                    },
                  );
                } else if (state is SearchError) {
                  return Center(child: Text('Erro: ${state.message}'));
                } else {
                  return const Center(child: Text('Nenhum aluno encontrado.'));
                }
              },
            ),
            const SizedBox(height: 20),
            Expanded(
              child: BlocBuilder<UserPacoteTreinoBloc, UserPacoteTreinoState>(
                builder: (context, userPacoteTreinoState) {
                  if (userPacoteTreinoState is UserPacoteTreinoLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (userAlunoId == null) {
                    return const Center(child: Text('Selecione um aluno para carregar os pacotes.'));
                  } else if (userPacoteTreinoState is UserPacoteTreinoLoaded) {
                    if (userPacoteTreinoState.userPacotesTreino.isEmpty) {
                      return const Center(child: Text('Nenhum pacote vinculado a este aluno.'));
                    } else {
                      final pacotesAgrupados = _agruparPacotesPorNome(userPacoteTreinoState.userPacotesTreino, context);
                      return ListView(
                        children: pacotesAgrupados.keys.map((nomePacote) {
                          final pacotes = pacotesAgrupados[nomePacote]!;
                          return ExpansionTile(
                            title: Text(
                              nomePacote,
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            initiallyExpanded: expandedState[nomePacote] ?? false,
                            onExpansionChanged: (expanded) {
                              setState(() {
                                expandedState[nomePacote] = expanded;
                              });
                            },
                            children: pacotes.map((userPacote) {
                              final pacote = (context.read<PacoteBloc>().state as PacotesLoaded)
                                  .pacotes
                                  .firstWhere((p) => p.id == userPacote.pacoteId);
                              final treinador = context.read<AuthenticationBloc>().getAuthenticatedUser();
                              return ListTile(
                                title: Text('${pacote.letraDivisao} - ${pacote.tipoTreino}'),
                                subtitle: Text('Treinador: ${treinador!.fullName}'),
                                trailing: IconButton(
                                  icon: const Icon(Icons.delete, color: Colors.red),
                                  onPressed: () {
                                    context.read<UserPacoteTreinoBloc>().add(DeleteUserPacoteTreino(userPacote.id!));
                                    context.read<UserPacoteTreinoBloc>().add(LoadUserPacotesTreino(userAlunoId!));
                                    context.read<PacoteBloc>().add(LoadPacotes());
                                  },
                                ),
                              );
                            }).toList(),
                          );
                        }).toList(),
                      );
                    }
                  } else if (userPacoteTreinoState is UserPacoteTreinoError) {
                    return Center(child: Text('Erro: ${userPacoteTreinoState.message}'));
                  } else {
                    return const Center(child: Text('Selecione um aluno para carregar os pacotes.'));
                  }
                },
              ),
            ),
            if (userAlunoId != null) ...[
              const Divider(),
              const Text('Pacotes Disponíveis', style: TextStyle(fontWeight: FontWeight.bold)),
              Expanded(
                child: BlocBuilder<PacoteBloc, PacoteState>(
                  builder: (context, state) {
                    if (state is PacoteLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is PacotesLoaded) {
                      final pacotesAgrupados = _agruparPacotesNaoVinculadosPorNome(state.pacotes, context);
                      return ListView(
                        children: pacotesAgrupados.keys.map((nomePacote) {
                          final pacotes = pacotesAgrupados[nomePacote]!;
                          return ExpansionTile(
                            title: Text(
                              nomePacote,
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            initiallyExpanded: expandedState[nomePacote] ?? false,
                            onExpansionChanged: (expanded) {
                              setState(() {
                                expandedState[nomePacote] = expanded;
                              });
                            },
                            children: pacotes.map((pacote) {
                              return ListTile(
                                title: Text('${pacote.letraDivisao} - ${pacote.tipoTreino}'),
                                trailing: IconButton(
                                  icon: const Icon(Icons.add, color: Colors.green),
                                  onPressed: () {
                                    final userPacoteTreino = UserPacoteTreino(
                                      createdAt: DateTime.now(),
                                      updatedAt: DateTime.now(),
                                      valido: true,
                                      pacoteId: pacote.id!,
                                      treinadorId: context.read<AuthenticationBloc>().getAuthenticatedUser()!.id!,
                                      alunoId: userAlunoId!,
                                    );
                                    context.read<UserPacoteTreinoBloc>().add(CreateUserPacoteTreino(userPacoteTreino));
                                    context.read<UserPacoteTreinoBloc>().add(LoadUserPacotesTreino(userAlunoId!));
                                    context.read<PacoteBloc>().add(LoadPacotes());
                                  },
                                ),
                              );
                            }).toList(),
                          );
                        }).toList(),
                      );
                    } else if (state is PacoteError) {
                      return Center(child: Text('Erro: ${state.message}'));
                    } else {
                      return const Center(child: Text('Nenhum pacote disponível.'));
                    }
                  },
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Map<String, List<UserPacoteTreino>> _agruparPacotesPorNome(
    List<UserPacoteTreino> userPacotesTreino, BuildContext context) {
  final pacotesAgrupados = <String, List<UserPacoteTreino>>{};

  for (var userPacote in userPacotesTreino) {
    // Aguarda até que o estado seja PacotesLoaded
    final pacoteState = context.read<PacoteBloc>().state;
    if (pacoteState is! PacotesLoaded) {
      return {}; // Retorna vazio ou algum valor padrão enquanto espera o estado correto
    }
    
    final pacote = pacoteState.pacotes.firstWhere((p) => p.id == userPacote.pacoteId);
    
    if (!pacotesAgrupados.containsKey(pacote.nomePacote)) {
      pacotesAgrupados[pacote.nomePacote] = [];
    }
    pacotesAgrupados[pacote.nomePacote]!.add(userPacote);
  }
  
  return pacotesAgrupados;
}

Map<String, List<Pacote>> _agruparPacotesNaoVinculadosPorNome(
    List<Pacote> pacotes, BuildContext context) {
  final pacotesAgrupados = <String, List<Pacote>>{};

  final userPacoteTreinoState = context.read<UserPacoteTreinoBloc>().state;
  final vinculadoIds = (userPacoteTreinoState is UserPacoteTreinoLoaded)
      ? userPacoteTreinoState.pacoteIds
      : [];

  for (var pacote in pacotes) {
    if (!vinculadoIds.contains(pacote.id)) {

      final pacoteState = context.read<PacoteBloc>().state;
      
      if (pacoteState is! PacotesLoaded) {
        return {};
      }
      
      if (!pacotesAgrupados.containsKey(pacote.nomePacote)) {
        pacotesAgrupados[pacote.nomePacote] = [];
      }
      pacotesAgrupados[pacote.nomePacote]!.add(pacote);
    }
  }

  return pacotesAgrupados;
}

}
