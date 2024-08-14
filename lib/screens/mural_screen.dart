import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:guido_power_academia/widgets/mural/mural_actions.dart';
import '../blocs/mural/mural_bloc.dart';
import '../blocs/mural/mural_event.dart';
import '../blocs/mural/mural_state.dart';
import '../widgets/mural/mural_card.dart';
import '../blocs/user/user_bloc.dart';
import '../blocs/theme/theme_bloc.dart';
import '../blocs/theme/theme_state.dart';

class MuralScreen extends StatelessWidget {
  const MuralScreen({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<MuralBloc>().add(LoadMurals());

    return Scaffold(
      body: BlocBuilder<MuralBloc, MuralState>(
        builder: (context, state) {
          if (state is MuralLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is MuralLoaded) {
            return ListView.builder(
              itemCount: state.murals.length,
              itemBuilder: (context, index) {
                final mural = state.murals[index];
                return MuralCard(mural: mural);
              },
            );
          } else if (state is MuralError) {
            return Center(child: Text(state.murals));
          } else {
            return const Center(child: Text('Nenhum mural encontrado.'));
          }
        },
      ),
      floatingActionButton: _buildFloatingActionButton(context),
    );
  }

  Widget _buildFloatingActionButton(BuildContext context) {
    final userState = context.read<UserBloc>().state;

    if (userState is UserLoaded) {
      final user = userState.user;
      if (user.accountType == 'treinador' || user.accountType == 'admin') {
        return BlocBuilder<ThemeBloc, ThemeState>(
          builder: (context, state) {
            return FloatingActionButton(
              onPressed: () => const MuralActions().showAddMuralDialog(context),
              backgroundColor: state.themeData.appBarTheme.backgroundColor,
              child: Icon(
                Icons.add,
                color: state.themeData.iconTheme.color,
              ),
            );
          },
        );
      }
    }

    return Container();
  }
}
