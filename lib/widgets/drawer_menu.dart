import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/user/user_bloc.dart';
import 'dart:convert';

class DrawerMenu extends StatelessWidget {
  const DrawerMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          BlocBuilder<UserBloc, UserState>(
            builder: (context, state) {
              if (state is UserLoaded) {
                return UserAccountsDrawerHeader(
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
                  decoration: const BoxDecoration(
                    color: Colors.purple,
                  ),
                );
              } else if (state is UserLoading) {
                return const DrawerHeader(
                  decoration: BoxDecoration(
                    color: Colors.purple,
                  ),
                  child: Center(child: CircularProgressIndicator()),
                );
              } else {
                return const DrawerHeader(
                  decoration: BoxDecoration(
                    color: Colors.purple,
                  ),
                  child: Text('Menu'),
                );
              }
            },
          ),
          ListTile(
            title: const Text('Home'),
            onTap: () {
              Navigator.pushNamed(context, '/home');
            },
          ),
          ListTile(
            title: const Text('Perfil'),
            onTap: () {
              // Implementar ação de perfil
            },
          ),
          ListTile(
            title: const Text('Configurações'),
            onTap: () {
              // Implementar ação de configurações
            },
          ),
          const Spacer(), // Adiciona espaço entre os itens e o botão de logout
          ListTile(
            title: const Text('Logout', style: TextStyle(color: Colors.red)),
            onTap: () {
              // Implementar ação de logout
              Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
            },
          ),
        ],
      ),
    );
  }
}
