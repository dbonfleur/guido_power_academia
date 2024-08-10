import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'blocs/authentication/authentication_bloc.dart';
import 'blocs/registration/registration_bloc.dart';
import 'blocs/theme/theme_bloc.dart';
import 'blocs/theme/theme_state.dart';
import 'blocs/user/user_bloc.dart';
import 'repositories/user_repository.dart';
import 'services/database_helper.dart';
import 'screens/login_screen.dart';
import 'screens/registration_screen.dart';
import 'screens/home_screen.dart';
import 'screens/intro_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }

  final userRepository = UserRepository(DatabaseHelper.instance);

  final prefs = await SharedPreferences.getInstance();
  final bool introSeen = prefs.getBool('introSeen') ?? false;

  runApp(MyApp(userRepository: userRepository, introSeen: introSeen));
}

class MyApp extends StatelessWidget {
  final UserRepository userRepository;
  final bool introSeen;

  const MyApp({super.key, required this.userRepository, required this.introSeen});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthenticationBloc>(
          create: (context) => AuthenticationBloc(userRepository),
        ),
        BlocProvider<RegistrationBloc>(
          create: (context) => RegistrationBloc(userRepository),
        ),
        BlocProvider<ThemeBloc>(
          create: (context) => ThemeBloc(),
        ),
        BlocProvider<UserBloc>( 
          create: (context) => UserBloc(userRepository),
        ),
      ],
      child: BlocBuilder<ThemeBloc, ThemeState>(
        builder: (context, state) {
          return MaterialApp(
            title: 'Guido Power Academia',
            debugShowCheckedModeBanner: false,
            theme: state.themeData,
            initialRoute: introSeen ? '/' : '/intro',
            // initialRoute: '/intro',
            routes: {
              '/': (context) => const LoginScreen(),
              '/register': (context) => const RegistrationScreen(),
              '/home': (context) => HomeScreen(),
              '/intro': (context) => const IntroScreen(),
            },
          );
        },
      ),
    );
  }
}
