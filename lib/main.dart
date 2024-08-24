import 'dart:io';
import 'package:desktop_window/desktop_window.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nested/nested.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'blocs/treino/pacote_bloc.dart';
import 'repositories/historico_treino_repository.dart';
import 'repositories/pacote_repository.dart';
import 'repositories/pacote_treino_repository.dart';
import 'repositories/pesos_treino_repository.dart';
import 'repositories/user_pacote_treino_repository.dart';
import 'services/database_helper.dart';

import 'blocs/contract/contract_bloc.dart';
import 'blocs/search/search_bloc.dart';
import 'blocs/treino/historico_treino_bloc.dart';
import 'blocs/treino/pacote_treino_bloc.dart';
import 'blocs/treino/pesos_treino_bloc.dart';
import 'blocs/treino/treino_bloc.dart';
import 'blocs/treino/user_pacote_treino_bloc.dart';
import 'blocs/authentication/authentication_bloc.dart';
import 'blocs/mural/mural_event.dart';
import 'blocs/payment/payment_bloc.dart';
import 'blocs/registration/registration_bloc.dart';
import 'blocs/theme/theme_bloc.dart';
import 'blocs/theme/theme_state.dart';
import 'blocs/trainer/trainer_bloc.dart';
import 'blocs/user/user_bloc.dart';
import 'blocs/mural/mural_bloc.dart';

import 'repositories/contract_repository.dart';
import 'repositories/payment_repository.dart';
import 'repositories/user_repository.dart';
import 'repositories/mural_repository.dart';
import 'repositories/treino_repository.dart';

import 'screens/login_screen.dart';
import 'screens/registration_screen.dart';
import 'screens/home_screen.dart';
import 'screens/intro_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    await DesktopWindow.setMinWindowSize(const Size(600, 900));
    await DesktopWindow.setMaxWindowSize(const Size(600, 900));
    await DesktopWindow.setWindowSize(const Size(600, 900));
    
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }

  final prefs = await SharedPreferences.getInstance();
  final bool introSeen = prefs.getBool('introSeen') ?? false;

  runApp(MyApp(introSeen: introSeen));
}

class MyApp extends StatelessWidget {
  final userRepository = UserRepository(DatabaseHelper.instance);
  final muralRepository = MuralRepository(DatabaseHelper.instance);
  final treinoRepository = TreinoRepository(DatabaseHelper.instance);
  final contractRepository = ContractRepository(DatabaseHelper.instance);
  final paymentRepository = PaymentRepository(DatabaseHelper.instance);
  final pacoteRepository = PacoteRepository(DatabaseHelper.instance);
  final userPacoteTreinoRepository = UserPacoteTreinoRepository(DatabaseHelper.instance);
  final pacoteTreinoRepository = PacoteTreinoRepository(DatabaseHelper.instance);
  final historicoTreinoRepository = HistoricoTreinoRepository(DatabaseHelper.instance);
  final pesosTreinoRepository = PesosTreinoRepository(DatabaseHelper.instance);
  final bool introSeen;

  MyApp({super.key, required this.introSeen});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: blocProviders,
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

  List<SingleChildWidget> get blocProviders {
    return [
      BlocProvider<AuthenticationBloc>(
        create: (context) => AuthenticationBloc(userRepository),
      ),
      BlocProvider<RegistrationBloc>(
        create: (context) => RegistrationBloc(),
      ),
      BlocProvider<ThemeBloc>(
        create: (context) => ThemeBloc(),
      ),
      BlocProvider<UserBloc>(
        create: (context) => UserBloc(userRepository),
      ),
      BlocProvider<MuralBloc>(
        create: (context) => MuralBloc(muralRepo: muralRepository)..add(LoadMurals()),
      ),
      BlocProvider(
        create: (context) => TreinoBloc(treinoRepository),
      ),
      BlocProvider(
        create: (context) => UserPacoteTreinoBloc(userPacoteTreinoRepository),
      ),
      BlocProvider(
        create: (context) => PesosTreinoBloc(pesosTreinoRepository),
      ),
      BlocProvider(
        create: (context) => PacoteBloc(pacoteRepository),
      ),
      BlocProvider(
        create: (context) => PacoteTreinoBloc(pacoteTreinoRepository),
      ),
      BlocProvider(
        create: (context) => HistoricoTreinoBloc(historicoTreinoRepository),
      ),
      BlocProvider(
        create: (context) => TrainerBloc(userRepository),
      ),
      BlocProvider(
        create: (context) => SearchBloc(userRepository),
      ),
      BlocProvider(
        create: (context) => ContractBloc(contractRepository,)
      ),
      BlocProvider(
        create: (context) => PaymentBloc(paymentRepository)
      ),
    ];
  }
}
