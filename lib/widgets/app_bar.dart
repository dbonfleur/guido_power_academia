import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/theme/theme_bloc.dart';
import '../blocs/theme/theme_event.dart';
import '../blocs/theme/theme_state.dart';
import '../blocs/user/user_bloc.dart';
import 'dart:convert';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: Colors.purple,
      title: Row(
        children: [
          GestureDetector(
            onTap: () {
              Scaffold.of(context).openDrawer();
            },
            child: BlocBuilder<UserBloc, UserState>(
              builder: (context, state) {
                if (state is UserLoaded) {
                  return CircleAvatar(
                    backgroundColor: Colors.white,
                    backgroundImage: state.user.imageUrl != null
                        ? MemoryImage(base64Decode(state.user.imageUrl!))
                        : null,
                    child: state.user.imageUrl == null
                        ? const Icon(Icons.person, color: Colors.purple)
                        : null,
                  );
                } else if (state is UserLoading) {
                  return const CircularProgressIndicator();
                } else {
                  return const CircleAvatar(
                    backgroundColor: Colors.white,
                    child: Icon(Icons.person, color: Colors.purple),
                  );
                }
              },
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.notifications),
          onPressed: () {
            // Implementar ação de notificações
          },
        ),
        IconButton(
          icon: BlocBuilder<ThemeBloc, ThemeState>(
            builder: (context, state) {
              return Icon(state.isLightTheme ? Icons.brightness_3 : Icons.wb_sunny);
            },
          ),
          onPressed: () {
            BlocProvider.of<ThemeBloc>(context).add(ToggleThemeEvent());
          },
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
