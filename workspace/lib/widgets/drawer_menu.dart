import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/user/user_bloc.dart';
import '../blocs/theme/theme_bloc.dart';
import '../blocs/theme/theme_state.dart';
import 'dart:convert';

class DrawerMenu extends StatelessWidget {
  final void Function(int index) onItemTapped;
  final int selectedIndex;

  const DrawerMenu({
    super.key,
    required this.onItemTapped,
    required this.selectedIndex,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, themeState) {
        return SizedBox(
          width: MediaQuery.of(context).size.width * 0.45,
          child: Drawer(
            child: Column(
              children: <Widget>[
                BlocBuilder<UserBloc, UserState>(
                  builder: (context, state) {
                    if (state is UserLoaded) {
                      return Column(
                        children: [
                          Stack(
                            children: [
                              UserAccountsDrawerHeader(
                                accountName: Text(state.user.fullName),
                                accountEmail: Text(state.user.email),
                                currentAccountPicture: CircleAvatar(
                                  backgroundColor: Colors.white,
                                  backgroundImage: state.user.imageUrl != null
                                      ? MemoryImage(base64Decode(state.user.imageUrl!))
                                      : null,
                                  child: state.user.imageUrl == null
                                      ? Icon(Icons.person, color: themeState.themeData.appBarTheme.backgroundColor)
                                      : null,
                                ),
                                decoration: BoxDecoration(
                                  color: themeState.themeData.primaryColor,
                                ),
                              ),
                              Positioned(
                                top: 8,
                                right: 8,
                                child: IconButton(
                                  icon: Icon(
                                    Icons.settings,
                                    color: themeState.themeData.iconTheme.color,
                                  ),
                                  onPressed: () {
                                    onItemTapped(4);
                                  },
                                ),
                              ),
                            ],
                          ),
                          _buildMenuItem(
                            context,
                            themeState,
                            icon: Icons.home,
                            text: 'Início',
                            index: 0,
                            selectedIndex: selectedIndex,
                          ),
                          _buildMenuItem(
                            context,
                            themeState,
                            icon: Icons.fitness_center,
                            text: 'Treinos',
                            index: 1,
                            selectedIndex: selectedIndex,
                          ),
                          _buildMenuItem(
                            context,
                            themeState,
                            icon: Icons.attach_money,
                            text: 'Financeiro',
                            index: 2,
                            selectedIndex: selectedIndex,
                          ),
                          _buildMenuItem(
                            context,
                            themeState,
                            icon: Icons.assignment,
                            text: 'Contrato',
                            index: 3,
                            selectedIndex: selectedIndex,
                          ),
                          if (state.user.accountType == 'admin') 
                            _buildMenuItem(
                              context,
                              themeState,
                              icon: Icons.group,
                              text: 'Treinadores',
                              index: 5,
                              selectedIndex: selectedIndex,
                            ),
                          if (state.user.accountType == 'admin' || state.user.accountType == 'treinador')
                            _buildMenuItem(
                              context,
                              themeState,
                              icon: Icons.person,
                              text: 'Alunos',
                              index: 6,
                              selectedIndex: selectedIndex,
                            ),
                        ],
                      );
                    } else if (state is UserLoading) {
                      return DrawerHeader(
                        decoration: BoxDecoration(
                          color: themeState.themeData.primaryColor,
                        ),
                        child: const Center(child: CircularProgressIndicator()),
                      );
                    } else {
                      return DrawerHeader(
                        decoration: BoxDecoration(
                          color: themeState.themeData.primaryColor,
                        ),
                        child: const Text('Menu'),
                      );
                    }
                  },
                ),
                const Spacer(),
                ListTile(
                  leading: const Icon(Icons.exit_to_app, color: Colors.red),
                  title: const Text('Deslogar', style: TextStyle(color: Colors.red)),
                  onTap: () async {
                    context.read<UserBloc>().add(LogoutUserEvent());
                    Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildMenuItem(
    BuildContext context,
    ThemeState themeState, {
    required IconData icon,
    required String text,
    required int index,
    required int selectedIndex,
  }) {
    final bool isSelected = index == selectedIndex;

    return ListTile(
      leading: Icon(
        icon,
        color: isSelected
            ? (themeState.themeData.brightness == Brightness.dark
                  ? Colors.black
                  : Colors.white)
            : themeState.themeData.primaryIconTheme.color,
      ),
      title: Text(
        text,
        style: TextStyle(
          color: isSelected
              ? (themeState.themeData.brightness == Brightness.dark
                  ? Colors.black
                  : Colors.white)
              : themeState.themeData.textTheme.bodyMedium?.color,
        ),
      ),
      tileColor: isSelected
          ? (themeState.themeData.brightness == Brightness.dark
              ? Colors.white
              : themeState.themeData.appBarTheme.backgroundColor)
          : null,
      shape: isSelected
          ? const RoundedRectangleBorder(
              borderRadius: BorderRadius.horizontal(left: Radius.circular(20)),
            )
          : null,
      onTap: () {
        onItemTapped(index);
      },
    );
  }
}