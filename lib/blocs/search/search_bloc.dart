import 'package:flutter_bloc/flutter_bloc.dart';

import '../../repositories/user_repository.dart';
import 'search_event.dart';
import 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final UserRepository userRepository;
  
  SearchBloc(this.userRepository) : super(SearchInitial()) {
    on<LoadUsersByFullName>(_onLoadUsersByFullName);
  }

  Future<void> _onLoadUsersByFullName(
    LoadUsersByFullName event,
    Emitter<SearchState> emit,
  ) async {
    emit(SearchLoading());
    try {
      final users = await userRepository.getUsersByFullName(event.fullName);
      final filteredUsers = users.where((user) =>
          user.fullName.toLowerCase().startsWith(event.fullName.toLowerCase()) &&
          user.accountType != 'treinador' &&
          user.accountType != 'admin').toList();
      emit(SearchUsersLoaded(filteredUsers));
    } catch (e) {
      emit(SearchError(e.toString()));
    }
  }
}