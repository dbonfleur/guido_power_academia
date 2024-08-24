import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:guido_power_academia/blocs/treino/user_pacote_treino_bloc.dart';

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
  Future<void> _loadData(BuildContext context) async {
    final userBloc = context.read<UserBloc>();
    final userState = userBloc.state;

    if (userState is UserLoaded) {
      final userId = userState.user.id;

      context.read<UserPacoteTreinoBloc>().add(LoadUserPacotesTreino(userId!));

      await for (final userPacoteTreinoState
          in context.read<UserPacoteTreinoBloc>().stream) {
        if (userPacoteTreinoState is UserPacoteTreinoLoaded) {
          final validPacotesTreino = userPacoteTreinoState.userPacotesTreino
              .where((pacoteTreino) => pacoteTreino.valido)
              .toList();

          if (validPacotesTreino.isEmpty) {
            return;
          }

          context.read<PacoteTreinoBloc>().add(LoadPacoteTreinosById(validPacotesTreino.first.id!));

          await for (final pacoteTreinoState
              in context.read<PacoteTreinoBloc>().stream) {
            if (pacoteTreinoState is PacoteTreinosByIdLoaded) {
              final treinoIds = pacoteTreinoState.pacoteTreino.treinoIds;

              context
                  .read<TreinoBloc>()
                  .add(LoadTreinosByIds(treinoIds));

              await for (final treinoState in context.read<TreinoBloc>().stream) {
                if (treinoState is TreinosByIdLoaded) {
                  setState(() {
                    // TODO: Implementar a lógica de exibição dos treinos
                  });
                  return;
                }
              }
            }
          }
        }
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _loadData(context);
  }

  @override
  Widget build(BuildContext context) {
    final userPacoteTreinoState = context.watch<UserPacoteTreinoBloc>().state;
    final pacoteTreinoState = context.watch<PacoteTreinoBloc>().state;
    final treinoState = context.watch<TreinoBloc>().state;

    if (userPacoteTreinoState is UserPacoteTreinoLoaded &&
        pacoteTreinoState is PacotesTreinoLoaded &&
        treinoState is TreinosByIdLoaded) {
      return ListView.builder(
        itemCount: treinoState.treinos.length,
        itemBuilder: (context, index) {
          final treino = treinoState.treinos[index];
          return ListTile(
            title: Text(treino.nome),
            subtitle: Text('${treino.qtdSeries} x ${treino.qtdRepeticoes}'),
          );
        },
      );
    } else if (userPacoteTreinoState is UserPacoteTreinoLoaded &&
        userPacoteTreinoState.userPacotesTreino
            .where((pacoteTreino) => pacoteTreino.valido)
            .isEmpty) {
      return const Center(
        child: Text(
            'Não há treinos disponíveis. Entre em contato com um treinador.'),
      );
    } else {
      return const Center(child: CircularProgressIndicator());
    }
  }
}
