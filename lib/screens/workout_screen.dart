import 'package:flutter/material.dart';
import '../widgets/treino/aluno_workout_widget.dart';
import '../widgets/treino/treinador_admin_workout_widget.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/user/user_bloc.dart';

class WorkoutScreen extends StatelessWidget {
  const WorkoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserBloc, UserState>(
      builder: (context, state) {
        if (state is UserLoaded) {
          final user = state.user;
          if (user.accountType == 'aluno') {
            return const AlunoWorkoutWidget();
          } else if (user.accountType == 'treinador' || user.accountType == 'admin') {
            return const TreinadorAdminWorkoutWidget();
          } else {
            return const SizedBox.shrink();
          }
        } else if (state is UserLoading) {
          return const Center(child: CircularProgressIndicator());
        } else {
          return const Center(child: Text('Erro ao carregar os dados do usuário'));
        }
      },
    );
  }
}
