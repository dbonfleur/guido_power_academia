import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:guido_power_academia/blocs/theme/theme_bloc.dart';
import 'package:guido_power_academia/blocs/theme/theme_state.dart';

import '../../blocs/treino/pacote_bloc.dart';
import '../../blocs/treino/pacote_event.dart';
import '../../blocs/treino/pacote_state.dart';
import '../../blocs/treino/pacote_treino_bloc.dart';
import '../../blocs/treino/pacote_treino_event.dart';
import '../../blocs/treino/pacote_treino_state.dart';
import '../../blocs/treino/treino_bloc.dart';
import '../../blocs/treino/treino_event.dart';
import '../../blocs/treino/treino_state.dart';
import '../../models/treino_model/pacote.dart';
import '../../models/treino_model/treino.dart';
import 'multi_select_workout_dropdown.dart';

class TreinadorAdminWorkoutWidget extends StatefulWidget {
  const TreinadorAdminWorkoutWidget({super.key});

  @override
  _TreinadorAdminWorkoutWidgetState createState() =>
      _TreinadorAdminWorkoutWidgetState();
}

class _TreinadorAdminWorkoutWidgetState
    extends State<TreinadorAdminWorkoutWidget> {
  @override
  void initState() {
    super.initState();
    context.read<TreinoBloc>().add(LoadTreinos());
    context.read<PacoteBloc>().add(LoadPacotes());
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: BlocBuilder<TreinoBloc, TreinoState>(
        builder: (context, treinoState) {
          return BlocBuilder<PacoteBloc, PacoteState>(
            builder: (context, pacoteState) {
              return ExpansionPanelList.radio(
                children: [
                  _buildAddTreinoPanel(context),
                  _buildAddPacotePanel(context),
                  _buildViewTreinosPanel(context),
                  _buildViewPacotesPanel(context),
                ],
              );
            },
          );
        },
      ),
    );
  }

  ExpansionPanelRadio _buildAddTreinoPanel(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final TextEditingController nomeController = TextEditingController();
    final TextEditingController seriesController = TextEditingController();
    final TextEditingController repeticoesController = TextEditingController();

    return ExpansionPanelRadio(
      value: 0,
      headerBuilder: (context, isExpanded) {
        return const ListTile(
          leading: Icon(Icons.fitness_center),
          title: Text("Adicionar Treino"),
        );
      },
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              TextFormField(
                controller: nomeController,
                decoration: const InputDecoration(
                  labelText: 'Nome do Treino',
                  prefixIcon: Icon(Icons.title),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira o nome do treino';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: seriesController,
                      decoration: const InputDecoration(
                        labelText: 'Séries',
                        prefixIcon: Icon(Icons.format_list_numbered),
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor, insira a quantidade de séries';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 16.0),
                  Expanded(
                    child: TextFormField(
                      controller: repeticoesController,
                      decoration: const InputDecoration(
                        labelText: 'Repetições',
                        prefixIcon: Icon(Icons.repeat),
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor, insira a quantidade de repetições';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20.0),
              BlocBuilder<ThemeBloc, ThemeState>(builder: (context, state) {
                return ElevatedButton(
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      final novoTreino = Treino(
                        nome: nomeController.text,
                        qtdSeries: int.parse(seriesController.text),
                        qtdRepeticoes: repeticoesController.text,
                        createdAt: DateTime.now(),
                        updatedAt: DateTime.now(),
                      );
                      context.read<TreinoBloc>().add(CreateTreino(novoTreino));
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        state.themeData.appBarTheme.backgroundColor,
                    foregroundColor: state.themeData.iconTheme.color,
                  ),
                  child: const Text("Adicionar Treino"),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  ExpansionPanelRadio _buildAddPacotePanel(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final TextEditingController nomePacoteController = TextEditingController();
    final TextEditingController letraDivisaoController =
        TextEditingController();
    final TextEditingController tipoTreinoController = TextEditingController();
    List<Treino> selectedTreinos = [];

    return ExpansionPanelRadio(
      value: 1,
      headerBuilder: (context, isExpanded) {
        return const ListTile(
          leading: Icon(Icons.add_box),
          title: Text("Adicionar Pacote de Treino"),
        );
      },
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              TextFormField(
                controller: nomePacoteController,
                decoration: const InputDecoration(
                  labelText: 'Nome do Pacote de Treino',
                  prefixIcon: Icon(Icons.fitness_center),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira o nome do pacote de treino';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: letraDivisaoController,
                decoration: const InputDecoration(
                  labelText: 'Letra da Divisão',
                  prefixIcon: Icon(Icons.abc),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira a letra da divisão';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: tipoTreinoController,
                decoration: const InputDecoration(
                  labelText: 'Tipo de Treino',
                  prefixIcon: Icon(Icons.category),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira o tipo de treino';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              BlocBuilder<TreinoBloc, TreinoState>(
                builder: (context, state) {
                  if (state is TreinosLoaded) {
                    return MultiSelectWorkoutDropdown(
                      workoutList: state.treinos,
                      onChanged: (List<Treino> selected) {
                        selectedTreinos = selected;
                      },
                    );
                  } else if (state is TreinoLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else {
                    return const Text("Erro ao carregar treinos disponíveis.");
                  }
                },
              ),
              const SizedBox(height: 20.0),
              BlocBuilder<ThemeBloc, ThemeState>(builder: (context, state) {
                return ElevatedButton(
                  onPressed: () {
                    if (formKey.currentState!.validate() &&
                        selectedTreinos.isNotEmpty) {
                      final novoPacote = Pacote(
                        nomePacote: nomePacoteController.text,
                        letraDivisao: letraDivisaoController.text,
                        tipoTreino: tipoTreinoController.text,
                        createdAt: DateTime.now(),
                        updatedAt: DateTime.now(),
                      );
                      context
                          .read<PacoteBloc>()
                          .add(CreatePacote(novoPacote, selectedTreinos));
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        state.themeData.appBarTheme.backgroundColor,
                    foregroundColor: state.themeData.iconTheme.color,
                  ),
                  child: const Text("Adicionar Pacote de Treino"),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  ExpansionPanelRadio _buildViewTreinosPanel(BuildContext context) {
    return ExpansionPanelRadio(
      value: 2,
      headerBuilder: (context, isExpanded) {
        return const ListTile(
          leading: Icon(Icons.view_list),
          title: Text("Visualizar Treinos"),
        );
      },
      body: BlocBuilder<TreinoBloc, TreinoState>(
        builder: (context, state) {
          if (state is TreinosLoaded) {
            return ListView.builder(
              shrinkWrap: true,
              itemCount: state.treinos.length,
              itemBuilder: (context, index) {
                final treino = state.treinos[index];
                return ListTile(
                  title: Text(treino.nome),
                  subtitle:
                      Text('${treino.qtdSeries} x ${treino.qtdRepeticoes}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () {
                          // Lógica para editar o treino
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          context
                              .read<TreinoBloc>()
                              .add(DeleteTreino(treino.id!));
                        },
                      ),
                    ],
                  ),
                );
              },
            );
          } else if (state is TreinoLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is TreinoError) {
            return const Center(child: Text("Erro ao carregar treinos."));
          } else {
            return const Center(child: Text("Erro ao carregar treinos."));
          }
        },
      ),
    );
  }

  ExpansionPanelRadio _buildViewPacotesPanel(BuildContext context) {
    return ExpansionPanelRadio(
      value: 3,
      headerBuilder: (context, isExpanded) {
        return const ListTile(
          leading: Icon(Icons.view_list),
          title: Text("Visualizar Pacotes de Treino"),
        );
      },
      body: BlocBuilder<PacoteBloc, PacoteState>(
        builder: (context, pacoteState) {
          if (pacoteState is PacotesLoaded) {
            return ListView.builder(
              shrinkWrap: true,
              itemCount: pacoteState.pacotes.length,
              itemBuilder: (context, index) {
                final pacote = pacoteState.pacotes[index];
                return ExpansionTile(
                  title: Text(pacote.nomePacote),
                  subtitle:
                      Text('${pacote.letraDivisao} - ${pacote.tipoTreino}'),
                  onExpansionChanged: (isExpanded) {
                    if (isExpanded) {
                      context
                          .read<PacoteTreinoBloc>()
                          .add(LoadPacoteTreinosById(pacote.id!));
                    }
                  },
                  children: [
                    BlocBuilder<PacoteTreinoBloc, PacoteTreinoState>(
                      builder: (context, pacoteTreinoState) {
                        if (pacoteTreinoState is TreinoIdsLoaded) {
                          final treinoIds = pacoteTreinoState.treinoIds;

                          if (treinoIds.isNotEmpty) {
                            context
                                .read<TreinoBloc>()
                                .add(LoadTreinosByIds(treinoIds));
                          }

                          return BlocBuilder<TreinoBloc, TreinoState>(
                            builder: (context, treinoState) {
                              if (treinoState is TreinosByIdLoaded) {
                                final treinos = treinoState.treinos;
                                return ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: treinos.length,
                                  itemBuilder: (context, index) {
                                    final treino = treinos[index];
                                    return ListTile(
                                      title: Text(treino.nome),
                                      subtitle: Text(
                                          '${treino.qtdSeries} x ${treino.qtdRepeticoes}'),
                                    );
                                  },
                                );
                              } else if (treinoState is TreinoLoading) {
                                return const Center(
                                    child: CircularProgressIndicator());
                              } else if (treinoState is TreinoError) {
                                return const Center(
                                    child: Text("Erro ao carregar treinos."));
                              } else {
                                return const SizedBox();
                              }
                            },
                          );
                        } else if (pacoteTreinoState is PacotesTreinoLoading) {
                          return const Center(
                              child: CircularProgressIndicator());
                        } else if (pacoteTreinoState is PacoteTreinoError) {
                          return const Center(
                              child:
                                  Text("Erro ao carregar treinos do pacote."));
                        } else {
                          return const SizedBox();
                        }
                      },
                    ),
                  ],
                );
              },
            );
          } else if (pacoteState is PacoteLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (pacoteState is PacoteError) {
            return const Center(child: Text("Erro ao carregar pacotes."));
          } else {
            return const Center(child: Text("Erro ao carregar pacotes."));
          }
        },
      ),
    );
  }
}
