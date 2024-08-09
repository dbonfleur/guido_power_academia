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
                      return Stack(
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
                                  ? const Icon(Icons.person, color: Colors.purple)
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
                const Spacer(),
                ListTile(
                  leading: const Icon(Icons.exit_to_app, color: Colors.red),
                  title: const Text('Logout', style: TextStyle(color: Colors.red)),
                  onTap: () {
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
            : themeState.themeData.iconTheme.color
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
              : Colors.purple)
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
