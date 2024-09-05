import 'package:equatable/equatable.dart';

abstract class SearchEvent extends Equatable {
  const SearchEvent();

  @override
  List<Object?> get props => [];
}

class LoadUsersByFullName extends SearchEvent {
  final String fullName;

  const LoadUsersByFullName(this.fullName);

  @override
  List<Object?> get props => [fullName];
}