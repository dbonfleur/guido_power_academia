import 'package:equatable/equatable.dart';
import '../../models/mural_model.dart';

abstract class MuralState extends Equatable {
  const MuralState();

  @override
  List<Object?> get props => [];
}

class MuralLoading extends MuralState {}

class MuralLoaded extends MuralState {
  final List<Mural> murals;

  const MuralLoaded({required this.murals});

  @override
  List<Object?> get props => [murals];
}

class MuralError extends MuralState {
  final String murals;

  const MuralError(this.murals);

  @override
  List<Object?> get props => [murals];
}
