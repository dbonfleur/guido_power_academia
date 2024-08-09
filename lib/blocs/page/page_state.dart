import 'package:equatable/equatable.dart';

abstract class PageState extends Equatable {
  const PageState();

  @override
  List<Object> get props => [];
}

class PageSelected extends PageState {
  final int index;

  const PageSelected(this.index);

  @override
  List<Object> get props => [index];
}
