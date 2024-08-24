import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:guido_power_academia/blocs/treino/user_pacote_treino_bloc.dart';

import '../../blocs/treino/user_pacote_treino_event.dart';
import '../../blocs/treino/user_pacote_treino_state.dart';

class AlunoWorkoutWidget extends StatelessWidget {
  const AlunoWorkoutWidget({super.key});

  @override
  Widget build(BuildContext context) {
    
    context.read<UserPacoteTreinoBloc>().add(LoadUserPacotesTreino());

    return BlocBuilder<UserPacoteTreinoBloc, UserPacoteTreinoState>(
      builder: (context, state) {
        if (state is UserPacoteTreinoLoaded) {
          if (state.userPacotesTreino.isEmpty) {
            return const Center(
              child: Text('Não há treinos disponíveis. Entre em contato com um treinador.'),
            );
          } else {
            return ListView.builder(
              itemCount: state.userPacotesTreino.length,
              itemBuilder: (context, index) {
                final pacoteTreino = state.userPacotesTreino[index].pacoteTreino;
                return ExpansionTile(
                  title: Text(pacoteTreino.treinos[index].nome),
                  children: pacoteTreino.treinos.map((treino) {
                    return ListTile(
                      title: Text(treino.nome),
                      subtitle: Text('${treino.qtdSeries} x ${treino.qtdRepeticoes}'),
                      trailing: IconButton(
                        icon: const Icon(Icons.play_arrow),
                        onPressed: () {
                          // Lógica para iniciar o treino e registrar pesos
                        },
                      ),
                    );
                  }).toList(),
                );
              },
            );
          }
        } else if (state is UserPacoteTreinoLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is UserPacoteTreinoError) {
          return Center(child: Text(state.message));
        } else if (state is UserPacoteTreinoInitial) {
          return const Center(
            child: Text('Carregando pacotes de treino...'),
          );
        } else {
          return const Center(child: Text('Erro desconhecido'));
        }
      },
    );
  }
}
