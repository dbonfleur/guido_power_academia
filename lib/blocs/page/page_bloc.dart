import 'package:flutter_bloc/flutter_bloc.dart';
import 'page_event.dart';
import 'page_state.dart';

class PageBloc extends Bloc<PageEvent, PageState> {
  PageBloc() : super(const PageSelected(0)) {
    on<PageTapped>((event, emit) {
      emit(PageSelected(event.index));
    });
  }
}
