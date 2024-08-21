part of 'contract_bloc.dart';

abstract class ContractEvent extends Equatable {
  const ContractEvent();

  @override
  List<Object?> get props => [];
}

class CreateContract extends ContractEvent {
  final Contract contract;

  const CreateContract({required this.contract});

  @override
  List<Object?> get props => [contract];
}

class LoadContractsByUser extends ContractEvent {
  final int userId;

  const LoadContractsByUser({required this.userId});

  @override
  List<Object?> get props => [userId];
}

class MarkContractAsCompleted extends ContractEvent {
  final int contractId;

  const MarkContractAsCompleted({required this.contractId});

  @override
  List<Object?> get props => [contractId];
}

class MarkContractInvalidOrValid extends ContractEvent {
  final int contractId;
  final bool isValid;

  const MarkContractInvalidOrValid({required this.contractId, required this.isValid});

  @override
  List<Object?> get props => [contractId, isValid];
}

