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
              backgroundColor: themeState.themeData.appBarTheme.backgroundColor,
              title: Row(
                children: [
                  Stack(
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
                                    ? Icon(Icons.person, color: themeState.themeData.appBarTheme.backgroundColor)
                                    : null,
                              )
                            : const CircularProgressIndicator(),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          decoration: BoxDecoration(
                            color: themeState.themeData.appBarTheme.backgroundColor,
                            shape: BoxShape.circle,
                          ),
                          padding: const EdgeInsets.all(2),
                          child: Icon(
                            Icons.menu,
                            size: 12,
                            color: themeState.themeData.iconTheme.color,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 8),
                  if (userState is UserLoaded)
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 6),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: userState.user.accountType == 'admin'
                              ? const Color.fromARGB(255, 17, 255, 0)
                              : (userState.user.accountType == 'treinador' ? Colors.yellow: Colors.transparent),
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        userState.user.accountType == 'admin'
                            ? 'Admin'
                            : (userState.user.accountType == 'treinador' ? 'Treinador' : ''),
                        style: TextStyle(
                          color: userState.user.accountType == 'admin'
                              ? const Color.fromARGB(255, 17, 255, 0)
                              : (userState.user.accountType == 'treinador' ? Colors.yellow : Colors.transparent),
                          fontSize: 14,
                        ),
                      ),
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
                    // Implementar notificações
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
