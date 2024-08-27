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
import '../models/treino_model/user_pacote_treino.dart';

class StudentScreen extends StatefulWidget {
  const StudentScreen({super.key});

  @override
  _StudentScreenState createState() => _StudentScreenState();
}

class _StudentScreenState extends State<StudentScreen> {
  int? userAlunoId;

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
                              backgroundImage:
                                  MemoryImage(base64Decode(user.imageUrl)),
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
                builder: (context, state) {
                  if (state is UserPacoteTreinoLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (userAlunoId == null) {
                    return const Center(
                        child: Text('Selecione um aluno para carregar os pacotes.'));
                  } else if (state is UserPacoteTreinoLoaded) {
                    if (state.userPacotesTreino.isEmpty) {
                      return const Center(
                          child: Text('Nenhum pacote vinculado a este aluno.'));
                    } else {
                      return Column(
                        children: [
                          const Text(
                            'Pacotes Vinculados',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Expanded(
                            child: ListView.builder(
                              itemCount: state.userPacotesTreino.length,
                              itemBuilder: (context, index) {
                                final pacote = state.userPacotesTreino[index];
                                return Card(
                                  child: ListTile(
                                    title: Text('Pacote ${pacote.pacoteId}'),
                                    subtitle: Text('Treinador: ${pacote.treinadorId}'),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      );
                    }
                  } else if (state is UserPacoteTreinoError) {
                    return Center(child: Text('Erro: ${state.message}'));
                  } else {
                    return const Center(
                        child: Text('Selecione um aluno para carregar os pacotes.'));
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
                      final pacotesNaoVinculados = state.pacotes.where((pacote) {
                        return !(context.read<UserPacoteTreinoBloc>().state as UserPacoteTreinoLoaded)
                            .pacoteIds
                            .contains(pacote.id);
                      }).toList();

                      return ListView.builder(
                        itemCount: pacotesNaoVinculados.length,
                        itemBuilder: (context, index) {
                          final pacote = pacotesNaoVinculados[index];
                          return ListTile(
                            title: Text(pacote.nomePacote),
                            subtitle: Text('Tipo: ${pacote.tipoTreino}'),
                            trailing: ElevatedButton(
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
                              child: const Text('Vincular'),
                            ),
                          );
                        },
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
}
