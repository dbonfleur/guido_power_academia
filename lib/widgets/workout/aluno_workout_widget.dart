import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:guido_power_academia/blocs/treino/user_pacote_treino_bloc.dart';
import '../../blocs/treino/pacote_bloc.dart';
import '../../blocs/treino/pacote_event.dart';
import '../../blocs/treino/pacote_state.dart';
import '../../blocs/treino/pacote_treino_bloc.dart';
import '../../blocs/treino/pacote_treino_event.dart';
import '../../blocs/treino/pacote_treino_state.dart';
import '../../blocs/treino/treino_bloc.dart';
import '../../blocs/treino/treino_event.dart';
import '../../blocs/treino/treino_state.dart';
import '../../blocs/treino/user_pacote_treino_event.dart';
import '../../blocs/treino/user_pacote_treino_state.dart';
import '../../blocs/user/user_bloc.dart';

class AlunoWorkoutWidget extends StatefulWidget {
  const AlunoWorkoutWidget({super.key});

  @override
  _AlunoWorkoutWidgetState createState() => _AlunoWorkoutWidgetState();
}

class _AlunoWorkoutWidgetState extends State<AlunoWorkoutWidget> {
  int? _selectedPacoteId;

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  void _loadInitialData() {
    final userBloc = context.read<UserBloc>();
    final userState = userBloc.state;

    if (userState is UserLoaded) {
      final userId = userState.user.id;
      context.read<UserPacoteTreinoBloc>().add(LoadUserPacotesTreino(userId!));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserPacoteTreinoBloc, UserPacoteTreinoState>(
      builder: (context, userPacoteTreinoState) {
        if (userPacoteTreinoState is UserPacoteTreinoLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (userPacoteTreinoState is UserPacoteTreinoLoaded) {
          final pacotesIds = userPacoteTreinoState.pacoteIds;

          if (pacotesIds.isEmpty) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                child: Text(
                  'Não há pacotes de treino disponíveis. Entre em contato com um treinador.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16),
                ),
              ),
            );
          }

          context.read<PacoteBloc>().add(LoadPacotesById(pacotesIds));

          return BlocBuilder<PacoteBloc, PacoteState>(
            builder: (context, pacoteState) {
              if (pacoteState is PacoteLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (pacoteState is PacotesLoaded) {
                final pacotes = pacoteState.pacotes;

                if (_selectedPacoteId == null && pacotes.isNotEmpty) {
                  _selectedPacoteId = pacotes.first.id;
                  context.read<PacoteTreinoBloc>().add(LoadPacoteTreinosById(_selectedPacoteId!));
                }

                if (_selectedPacoteId != null &&
                    !pacotes.map((p) => p.id).contains(_selectedPacoteId)) {
                  _selectedPacoteId = pacotes.first.id;
                  context.read<PacoteTreinoBloc>().add(LoadPacoteTreinosById(_selectedPacoteId!));
                }

                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: DropdownButtonFormField<int>(
                        decoration: InputDecoration(
                          labelText: 'Selecione um pacote',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        value: _selectedPacoteId,
                        onChanged: (int? newValue) {
                          setState(() {
                            _selectedPacoteId = newValue;
                          });
                          context.read<PacoteTreinoBloc>().add(
                              LoadPacoteTreinosById(_selectedPacoteId!));
                        },
                        items: pacotes.map<DropdownMenuItem<int>>((pacote) {
                          return DropdownMenuItem<int>(
                            value: pacote.id,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('${pacote.letraDivisao} - ${pacote.tipoTreino}'),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    Expanded(
                      child: BlocBuilder<PacoteTreinoBloc, PacoteTreinoState>(
                        builder: (context, pacoteTreinoState) {
                          if (pacoteTreinoState is PacotesTreinoLoading) {
                            return const Center(
                                child: CircularProgressIndicator());
                          } else if (pacoteTreinoState is TreinoIdsLoaded) {
                            final treinoIds = pacoteTreinoState.treinoIds;

                            context.read<TreinoBloc>().add(LoadTreinosByIds(treinoIds));

                            return BlocBuilder<TreinoBloc, TreinoState>(
                              builder: (context, treinoState) {
                                if (treinoState is TreinoLoading) {
                                  return const Center(
                                      child: CircularProgressIndicator());
                                } else if (treinoState is TreinosByIdLoaded) {
                                  final treinos = treinoState.treinos;

                                  return ListView.builder(
                                    itemCount: treinos.length,
                                    itemBuilder: (context, index) {
                                      final treino = treinos[index];
                                      return Card(
                                        child: ListTile(
                                          title: Text(treino.nome),
                                          subtitle: Text(
                                            '${treino.qtdSeries} x ${treino.qtdRepeticoes}',
                                          ),
                                          trailing: IconButton(
                                            icon: const Icon(Icons.expand_more),
                                            onPressed: () {
                                              // Implementar a função de expandir aqui
                                            },
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                } else {
                                  return const Center(
                                      child: CircularProgressIndicator());
                                }
                              },
                            );
                          } else {
                            return const Center(
                                child: CircularProgressIndicator());
                          }
                        },
                      ),
                    ),
                  ],
                );
              } else if (pacoteState is PacoteError) {
                return Center(
                    child: Text(
                        'Erro ao carregar os pacotes: ${pacoteState.message}'));
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            },
          );
        } else if (userPacoteTreinoState is UserPacoteTreinoError) {
          return Center(
              child: Text(
                  'Erro ao carregar pacotes de treino: ${userPacoteTreinoState.message}'));
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
