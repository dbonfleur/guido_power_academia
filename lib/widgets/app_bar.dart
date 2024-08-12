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
    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, themeState) {
        return BlocBuilder<UserBloc, UserState>(
          builder: (context, userState) {
            return AppBar(
              automaticallyImplyLeading: false,
              backgroundColor: themeState.themeData.primaryColor,
              title: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      Scaffold.of(context).openDrawer();
                    },
                    child: userState is UserLoaded
                        ? CircleAvatar(
                            backgroundColor: Colors.white,
                            backgroundImage: userState.user.imageUrl != null
                                ? MemoryImage(base64Decode(userState.user.imageUrl!))
                                : null,
                            child: userState.user.imageUrl == null
                                ? const Icon(Icons.person, color: Colors.purple)
                                : null,
                          )
                        : const CircularProgressIndicator(),
                  ),
                ],
              ),
              actions: [
                IconButton(
                  icon: Icon(
                    Icons.notifications,
                    color: themeState.themeData.iconTheme.color,
                  ),
                  onPressed: () {
                    // Implementar ação de notificações
                  },
                ),
                IconButton(
                  icon: Icon(
                    themeState.isLightTheme ? Icons.brightness_3 : Icons.wb_sunny,
                    color: themeState.themeData.iconTheme.color,
                  ),
                  onPressed: () {
                    BlocProvider.of<ThemeBloc>(context).add(ToggleThemeEvent());
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
