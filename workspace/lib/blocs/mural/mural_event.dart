import 'package:equatable/equatable.dart';
import '../../models/mural_model.dart';

abstract class MuralEvent extends Equatable {
  const MuralEvent();

  @override
  List<Object?> get props => [];
}

class LoadMurals extends MuralEvent {}

class AddMural extends MuralEvent {
  final Mural mural;

  const AddMural(this.mural);

  @override
  List<Object?> get props => [mural];
}

class UpdateMural extends MuralEvent {
  final Mural mural;

  const UpdateMural(this.mural);

  @override
  List<Object?> get props => [mural];
}

class DeleteMural extends MuralEvent {
  final int muralId;

  const DeleteMural(this.muralId);

  @override
  List<Object?> get props => [muralId];
}
