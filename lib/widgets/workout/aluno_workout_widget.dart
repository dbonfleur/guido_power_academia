import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/treino/pacote_bloc.dart';
import '../../blocs/treino/pacote_event.dart';
import '../../blocs/treino/pacote_state.dart';
import '../../blocs/treino/pacote_treino_bloc.dart';
import '../../blocs/treino/pacote_treino_event.dart';
import '../../blocs/treino/pacote_treino_state.dart';
import '../../blocs/treino/pesos_treino_bloc.dart';
import '../../blocs/treino/pesos_treino_event.dart';
import '../../blocs/treino/pesos_treino_state.dart';
import '../../blocs/treino/treino_bloc.dart';
import '../../blocs/treino/treino_event.dart';
import '../../blocs/treino/treino_state.dart';
import '../../blocs/treino/historico_treino_bloc.dart';
import '../../blocs/treino/historico_treino_event.dart';
import '../../blocs/treino/historico_treino_state.dart';
import '../../blocs/treino/user_pacote_treino_bloc.dart';
import '../../blocs/treino/user_pacote_treino_event.dart';
import '../../blocs/treino/user_pacote_treino_state.dart';
import '../../blocs/user/user_bloc.dart';
import '../../models/treino_model/historico_treino.dart';
import '../../models/treino_model/peso_treino.dart';

class AlunoWorkoutWidget extends StatefulWidget {
  const AlunoWorkoutWidget({super.key});

  @override
  _AlunoWorkoutWidgetState createState() => _AlunoWorkoutWidgetState();
}

class _AlunoWorkoutWidgetState extends State<AlunoWorkoutWidget> {
  bool isPacoteInitialized = false;
  Map<int, bool> treinoIniciado = {};
  Map<int, bool> treinoConcluido = {};

  @override
  Widget build(BuildContext context) {
    final userBloc = context.read<UserBloc>();
    final userState = userBloc.state;
    int? userId;

    if (userState is UserLoaded) {
      userId = userState.user.id;
      context.read<UserPacoteTreinoBloc>().add(LoadUserPacotesTreino(userId!));
      context.read<HistoricoTreinoBloc>().add(LoadHistoricoTreino());
      context.read<PesosTreinoBloc>().add(LoadPesosTreino(userId));
    }

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

                int selectedPacoteId = pacotes.first.id!;
                context
                    .read<PacoteTreinoBloc>()
                    .add(LoadPacoteTreinosById(selectedPacoteId));

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
                        value: selectedPacoteId,
                        onChanged: (int? newValue) {
                          context
                              .read<PacoteTreinoBloc>()
                              .add(LoadPacoteTreinosById(newValue!));
                        },
                        items: pacotes.map<DropdownMenuItem<int>>((pacote) {
                          return DropdownMenuItem<int>(
                            value: pacote.id,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                    '${pacote.letraDivisao} - ${pacote.tipoTreino}'),
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

                            context
                                .read<TreinoBloc>()
                                .add(LoadTreinosByIds(treinoIds));

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
                                      return BlocBuilder<PesosTreinoBloc, PesosTreinoState>(
                                        builder: (context, pesosTreinoState) {
                                          final pesoTreinoSalvo = (pesosTreinoState is PesosTreinoLoaded)
                                              ? pesosTreinoState.pesosTreinos.firstWhere(
                                                  (peso) => peso.pacoteTreinoId == treino.id,
                                                  orElse: () => PesosTreino(
                                                    createdAt: DateTime.now(),
                                                    pacoteTreinoId: treino.id!,
                                                    userId: userId!,
                                                  ),
                                                )
                                              : null;

                                          final isTrainingStarted = treinoIniciado[treino.id!] ?? false;
                                          final isTrainingCompleted = treinoConcluido[treino.id!] ?? false;

                                          return Card(
                                            child: Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(treino.nome),
                                                  const SizedBox(height: 4),
                                                  Text('${treino.qtdSeries} x ${treino.qtdRepeticoes}'),
                                                  const SizedBox(height: 8),
                                                  Row(
                                                    children: [
                                                      SizedBox(
                                                        width: 100,
                                                        child: TextFormField(
                                                          initialValue: pesoTreinoSalvo?.peso?.toString(),
                                                          onChanged: (value) {
                                                            final pesoAtualizado = PesosTreino(
                                                              id: pesoTreinoSalvo?.id,
                                                              createdAt: DateTime.now(),
                                                              pacoteTreinoId: treino.id!,
                                                              peso: int.tryParse(value),
                                                              userId: userId!,
                                                            );
                                                            context.read<PesosTreinoBloc>().add(UpdatePesosTreino(pesoAtualizado));
                                                          },
                                                          decoration: const InputDecoration(
                                                            labelText: 'Peso (kg)',
                                                            border: OutlineInputBorder(),
                                                          ),
                                                          keyboardType: TextInputType.number,
                                                          enabled: isTrainingStarted && !isTrainingCompleted,
                                                        ),
                                                      ),
                                                      const Spacer(),
                                                      if (isPacoteInitialized)
                                                        ElevatedButton(
                                                          onPressed: isTrainingCompleted
                                                              ? null
                                                              : () {
                                                                  setState(() {
                                                                    treinoIniciado[treino.id!] = !isTrainingStarted;
                                                                    treinoConcluido[treino.id!] = !treinoIniciado[treino.id!]!;
                                                                  });

                                                                  final pesoTreino = PesosTreino(
                                                                    createdAt: DateTime.now(),
                                                                    pacoteTreinoId: treino.id!,
                                                                    userId: userId!,
                                                                    peso: pesoTreinoSalvo?.peso,
                                                                  );
                                                                  if (isTrainingStarted) {
                                                                    context.read<PesosTreinoBloc>().add(UpdatePesosTreino(pesoTreino));
                                                                  } else {
                                                                    context.read<PesosTreinoBloc>().add(AddPesosTreino(pesoTreino));
                                                                  }
                                                                },
                                                          style: ElevatedButton.styleFrom(
                                                            backgroundColor: isTrainingCompleted
                                                                ? Colors.grey
                                                                : isTrainingStarted
                                                                    ? Colors.green
                                                                    : Colors.blue,
                                                          ),
                                                          child: Text(isTrainingStarted ? 'Concluir Treino' : 'Iniciar Treino'),
                                                        ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                        },
                                      );
                                    },
                                  );
                                } else {
                                  return const Center(child: CircularProgressIndicator());
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
                    BlocBuilder<HistoricoTreinoBloc, HistoricoTreinoState>(
                      builder: (context, historicoState) {
                        int timeInSeconds = 0;
                        if (historicoState is WorkoutTimeUpdated) {
                          timeInSeconds = historicoState.timeInSeconds;
                        }
                        return Column(
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                if (historicoState is WorkoutTimeStopped || historicoState is WorkoutTimeUpdated) {
                                  context.read<HistoricoTreinoBloc>().add(StopWorkoutTimer());
                                  final historicoTreino = HistoricoTreino(
                                    createdAt: DateTime.now(),
                                    tempoTreino: _formatTime(timeInSeconds),
                                    pacoteTreinoId: selectedPacoteId,
                                    alunoId: userId!,
                                  );
                                  context.read<HistoricoTreinoBloc>().add(SaveWorkoutTime(historicoTreino));
                                  setState(() {
                                    isPacoteInitialized = false;
                                    treinoIniciado.clear();
                                    treinoConcluido.clear();
                                  });
                                } else {
                                  context.read<HistoricoTreinoBloc>().add(StartWorkoutTimer());
                                  setState(() {
                                    isPacoteInitialized = true;
                                  });
                                }
                              },
                              child: Text(
                                historicoState is WorkoutTimeStopped || historicoState is HistoricoTreinoLoaded
                                    ? 'Iniciar Pacote'
                                    : 'Concluir Pacote: ${_formatTime(timeInSeconds)}',
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                );
              } else if (pacoteState is PacoteError) {
                return Center(child: Text('Erro ao carregar os pacotes: ${pacoteState.message}'));
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            },
          );
        } else if (userPacoteTreinoState is UserPacoteTreinoError) {
          return Center(child: Text('Erro ao carregar pacotes de treino: ${userPacoteTreinoState.message}'));
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '$minutes:${remainingSeconds.toString().padLeft(2, '0')}';
  }
}
