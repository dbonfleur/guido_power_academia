import 'package:equatable/equatable.dart';

abstract class PageEvent extends Equatable {
  const PageEvent();

  @override
  List<Object> get props => [];
}

class PageTapped extends PageEvent {
  final int index;

  const PageTapped(this.index);

  @override
  List<Object> get props => [index];
}
