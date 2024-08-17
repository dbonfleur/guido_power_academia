part of 'contract_bloc.dart';

abstract class ContractState extends Equatable {
  const ContractState();

  @override
  List<Object?> get props => [];
}

class ContractInitial extends ContractState {}

class ContractCreated extends ContractState {
  final int id;

  const ContractCreated({required this.id});

  @override
  List<Object?> get props => [id];
}

class ContractsLoaded extends ContractState {
  final List<Contract> contracts;

  const ContractsLoaded({required this.contracts});

  @override
  List<Object?> get props => [contracts];
}

class ContractError extends ContractState {
  final String message;

  const ContractError({required this.message});

  @override
  List<Object?> get props => [message];
}
