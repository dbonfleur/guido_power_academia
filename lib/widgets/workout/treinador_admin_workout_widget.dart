import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  Map<int, List<Treino>> treinosPorPacote = {};
  Set<int> expandedItems = {};
  bool showSelectAtLeastOneWarning = false;

  @override
  void initState() {
    super.initState();
    context.read<TreinoBloc>().add(LoadTreinos());
    context.read<PacoteBloc>().add(LoadPacotes());
  }

  void _carregarTreinos(int pacoteId) {
    treinosPorPacote.remove(pacoteId);
    if (!treinosPorPacote.containsKey(pacoteId)) {
      context.read<PacoteTreinoBloc>().add(LoadPacoteTreinosById(pacoteId));
    }
  }

  void _recarregarTreinos(int pacoteId) {
    context.read<PacoteTreinoBloc>().add(LoadPacoteTreinosById(pacoteId));
  }

  void _editarTreino(Treino treino) {
    final formKey = GlobalKey<FormState>();
    final TextEditingController nomeController =
        TextEditingController(text: treino.nome);
    final TextEditingController seriesController =
        TextEditingController(text: treino.qtdSeries.toString());
    final TextEditingController repeticoesController =
        TextEditingController(text: treino.qtdRepeticoes);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Editar Treino'),
          content: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
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
              ],
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  final updatedTreino = Treino(
                    id: treino.id,
                    nome: nomeController.text,
                    qtdSeries: int.parse(seriesController.text),
                    qtdRepeticoes: repeticoesController.text,
                    createdAt: treino.createdAt,
                    updatedAt: DateTime.now(),
                  );
                  context.read<TreinoBloc>().add(UpdateTreino(updatedTreino));
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Salvar'),
            ),
          ],
        );
      },
    );
  }

  void _editarPacote(Pacote pacote) {
    final formKey = GlobalKey<FormState>();
    final TextEditingController nomePacoteController =
        TextEditingController(text: pacote.nomePacote);
    final TextEditingController letraDivisaoController =
        TextEditingController(text: pacote.letraDivisao);
    final TextEditingController tipoTreinoController =
        TextEditingController(text: pacote.tipoTreino);
    List<Treino> selectedTreinos = treinosPorPacote[pacote.id!] ?? [];

    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.7,
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Form(
                    key: formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
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
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: letraDivisaoController,
                                decoration: const InputDecoration(
                                  labelText: 'Letra da Divisão',
                                  prefixIcon: Icon(Icons.abc),
                                  border: OutlineInputBorder(),
                                ),
                                buildCounter: (_,
                                    {required int currentLength,
                                    required bool isFocused,
                                    required int? maxLength}) {
                                  return null;
                                },
                                maxLength: 1,
                                inputFormatters: [
                                  FilteringTextInputFormatter
                                      .singleLineFormatter,
                                  UpperCaseTextFormatter(),
                                ],
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Por favor, insira a letra da divisão';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            const SizedBox(width: 16.0),
                            Expanded(
                              child: TextFormField(
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
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  BlocBuilder<TreinoBloc, TreinoState>(
                    builder: (context, state) {
                      if (state is TreinosLoaded) {
                        return MultiSelectWorkoutDropdown(
                          workoutList: state.treinos,
                          initiallySelected: selectedTreinos,
                          onChanged: (List<Treino> selected) {
                            selectedTreinos = selected;
                          },
                        );
                      } else if (state is TreinoLoading) {
                        return const Center(child: CircularProgressIndicator());
                      } else {
                        return const Text(
                            "Erro ao carregar treinos disponíveis.");
                      }
                    },
                  ),
                  const SizedBox(height: 16.0),
                  ElevatedButton(
                    onPressed: () {
                      if (formKey.currentState!.validate() &&
                          selectedTreinos.isNotEmpty) {
                        final updatedPacote = Pacote(
                          id: pacote.id,
                          nomePacote: nomePacoteController.text,
                          letraDivisao: letraDivisaoController.text,
                          tipoTreino: tipoTreinoController.text,
                          createdAt: pacote.createdAt,
                          updatedAt: DateTime.now(),
                        );
                        context
                            .read<PacoteBloc>()
                            .add(UpdatePacote(updatedPacote, selectedTreinos));
                        Navigator.of(context).pop();
                      } else {
                        setState(() {
                          showSelectAtLeastOneWarning = true;
                        });
                      }
                    },
                    child: const Text('Salvar'),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    ).then((_) {
      // Recarregar treinos após a edição do pacote
      _recarregarTreinos(pacote.id!);
    });
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
                  _buildViewTreinosPanel(context, treinoState),
                  _buildViewPacotesPanel(context, treinoState),
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
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: letraDivisaoController,
                      decoration: const InputDecoration(
                        labelText: 'Letra da Divisão',
                        prefixIcon: Icon(Icons.abc),
                        border: OutlineInputBorder(),
                      ),
                      buildCounter: (_,
                          {required int currentLength,
                          required bool isFocused,
                          required int? maxLength}) {
                        return null;
                      },
                      maxLength: 1,
                      inputFormatters: [
                        FilteringTextInputFormatter.singleLineFormatter,
                        UpperCaseTextFormatter(),
                      ],
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor, insira a letra da divisão';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 16.0),
                  Expanded(
                    child: TextFormField(
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
                  ),
                ],
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
                    if (selectedTreinos.isEmpty) {
                      setState(() {
                        showSelectAtLeastOneWarning = true;
                      });
                    } else if (formKey.currentState!.validate()) {
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
              if (showSelectAtLeastOneWarning && selectedTreinos.isEmpty)
                const Center(
                  child: Text(
                    'Selecione ao menos um treino',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  ExpansionPanelRadio _buildViewTreinosPanel(
      BuildContext context, TreinoState treinoState) {
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
                        color: context
                            .read<ThemeBloc>()
                            .state
                            .themeData
                            .listTileTheme
                            .iconColor,
                        onPressed: () {
                          _editarTreino(treino);
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        color: context
                            .read<ThemeBloc>()
                            .state
                            .themeData
                            .listTileTheme
                            .iconColor,
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

  ExpansionPanelRadio _buildViewPacotesPanel(
      BuildContext context, TreinoState treinoState) {
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
                final isExpanded = expandedItems.contains(pacote.id);

                return ExpansionTile(
                  title: Text(
                    pacote.nomePacote,
                    overflow: TextOverflow.ellipsis,
                  ),
                  onExpansionChanged: (expanded) {
                    setState(() {
                      if (expanded) {
                        expandedItems.add(pacote.id!);
                        _carregarTreinos(pacote.id!);
                      } else {
                        expandedItems.remove(pacote.id!);
                      }
                    });
                  },
                  subtitle:
                      Text('${pacote.letraDivisao} - ${pacote.tipoTreino}'),
                  trailing: isExpanded
                      ? Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () {
                                _editarPacote(pacote);
                              },
                              color: context
                                  .read<ThemeBloc>()
                                  .state
                                  .themeData
                                  .listTileTheme
                                  .iconColor,
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () {
                                context
                                    .read<PacoteBloc>()
                                    .add(DeletePacote(pacote.id!));
                              },
                              color: context
                                  .read<ThemeBloc>()
                                  .state
                                  .themeData
                                  .listTileTheme
                                  .iconColor,
                            ),
                            const SizedBox(width: 8.0),
                            Icon(Icons.keyboard_arrow_up,
                                color: context
                                    .read<ThemeBloc>()
                                    .state
                                    .themeData
                                    .expansionTileTheme
                                    .iconColor),
                          ],
                        )
                      : null,
                  children: [
                    BlocBuilder<PacoteTreinoBloc, PacoteTreinoState>(
                      builder: (context, pacoteTreinoState) {
                        if (pacoteTreinoState is TreinoIdsLoaded) {
                          final treinoIds = pacoteTreinoState.treinoIds;

                          if (treinoIds.isNotEmpty &&
                              treinoState is TreinosLoaded) {
                            final treinos = treinoState.treinos
                                .where(
                                    (treino) => treinoIds.contains(treino.id))
                                .toList();

                            treinosPorPacote[pacote.id!] = treinos;

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

class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    return TextEditingValue(
      text: newValue.text.toUpperCase(),
      selection: newValue.selection,
    );
  }
}
