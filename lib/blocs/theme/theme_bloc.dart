import 'package:flutter_bloc/flutter_bloc.dart';

import 'theme_event.dart';
import 'theme_state.dart';

class ThemeBloc extends Bloc<ToggleThemeEvent, ThemeState> {
  ThemeBloc() : super(ThemeState.light()) {
    on<ToggleThemeEvent>((event, emit) {
      emit(state.isLightTheme ? ThemeState.dark() : ThemeState.light());
    });
  }
}
