import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:guido_power_academia/blocs/search/search_bloc.dart';
import 'package:guido_power_academia/blocs/search/search_event.dart';
import 'package:guido_power_academia/blocs/search/search_state.dart';
import 'package:intl/intl.dart';
import '../../blocs/trainer/trainer_bloc.dart';
import '../../blocs/trainer/trainer_event.dart';
import '../../blocs/trainer/trainer_state.dart';

class TrainerScreen extends StatefulWidget {
  const TrainerScreen({super.key});

  @override
  _TrainerScreenState createState() => _TrainerScreenState();
}

class _TrainerScreenState extends State<TrainerScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<TrainerBloc>().add(LoadTrainers());
    context.read<SearchBloc>().add(const LoadUsersByFullName(''));

    _searchController.addListener(() {
      final query = _searchController.text.trim();
      context.read<SearchBloc>().add(LoadUsersByFullName(query));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                hintText: 'Digite o nome completo',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          BlocBuilder<SearchBloc, SearchState>(
            builder: (contextSearch, searchState) {
              return BlocBuilder<TrainerBloc, TrainerState>(
                builder: (contextTrainer, trainerState) {
                  if (searchState is SearchLoading || trainerState is TrainersLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (searchState is SearchUsersLoaded && trainerState is TrainersLoaded) {
                    final trainers = trainerState.trainers;
                    final usersToShow = searchState.users
                        .where((user) => !trainers.contains(user))
                        .toList();

                    if (usersToShow.isEmpty) {
                      return Expanded(
                        child: Center(
                          child: Text(
                            'Nenhum usuário encontrado.',
                            style: Theme.of(context).textTheme.labelLarge,
                          ),
                        ),
                      );
                    }
                    return Expanded(
                      child: Column(
                        children: [
                          Text('Resultados da pesquisa', style: Theme.of(context).textTheme.headlineMedium),
                          const SizedBox(height: 10),
                          Expanded(
                            child: ListView.builder(
                              itemCount: usersToShow.length,
                              itemBuilder: (context, index) {
                                final user = usersToShow[index];
                                final birthDate = _parseDate(user.dateOfBirth);
                                final age = _calculateAge(birthDate);

                                return Card(
                                  child: ListTile(
                                    leading: user.imageUrl != null
                                        ? Image.memory(
                                            base64Decode(user.imageUrl!),
                                            width: 50,
                                            height: 50,
                                            fit: BoxFit.cover,
                                          )
                                        : const Icon(Icons.person),
                                    title: Text(user.fullName),
                                    subtitle: Text('Idade: $age\nEmail: ${user.email}'),
                                    trailing: IconButton(
                                      icon: const Icon(Icons.add),
                                      onPressed: () {
                                        contextTrainer.read<TrainerBloc>().add(AddTrainer(user));
                                        contextSearch.read<SearchBloc>().add(LoadUsersByFullName(_searchController.text));
                                      },
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    );
                  } else if (searchState is SearchError) {
                    return Center(child: Text(searchState.message));
                  } else {
                    return const SizedBox.shrink();
                  }
                },
              );
            },
          ),
          const Divider(),
          Text('Treinadores', style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: 10),
          Expanded(
            child: BlocBuilder<TrainerBloc, TrainerState>(
              builder: (context, state) {
                if (state is TrainersLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is TrainersLoaded && state.trainers.isNotEmpty) {
                  return ListView.builder(
                    itemCount: state.trainers.length,
                    itemBuilder: (context, index) {
                      final user = state.trainers[index];
                      final birthDate = _parseDate(user.dateOfBirth);
                      final age = _calculateAge(birthDate);

                      return Card(
                        child: ListTile(
                          leading: user.imageUrl != null
                              ? Image.memory(
                                  base64Decode(user.imageUrl!),
                                  width: 50,
                                  height: 50,
                                  fit: BoxFit.cover,
                                )
                              : const Icon(Icons.person),
                          title: Text(user.fullName),
                          subtitle: Text('Idade: $age\nEmail: ${user.email}'),
                          trailing: IconButton(
                            icon: const Icon(Icons.remove),
                            onPressed: () {
                              context.read<TrainerBloc>().add(RemoveTrainer(user));
                              context.read<SearchBloc>().add(LoadUsersByFullName(_searchController.text));
                            },
                          ),
                        ),
                      );
                    },
                  );
                } else if (state is TrainerError) {
                  return Center(child: Text(state.message));
                } else {
                  return Center(child: Text('Nenhum treinador adicionado.', style: Theme.of(context).textTheme.labelLarge));
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  DateTime _parseDate(String dateString) {
    try {
      return DateFormat('dd/MM/yyyy').parse(dateString);
    } catch (e) {
      return DateTime(1900);
    }
  }

  int _calculateAge(DateTime birthDate) {
    final now = DateTime.now();
    int age = now.year - birthDate.year;
    if (now.month < birthDate.month || (now.month == birthDate.month && now.day < birthDate.day)) {
      age--;
    }
    return age;
  }
}
