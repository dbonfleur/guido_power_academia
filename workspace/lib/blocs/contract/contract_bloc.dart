import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/contract_model.dart';
import '../../repositories/contract_repository.dart';

part 'contract_event.dart';
part 'contract_state.dart';

class ContractBloc extends Bloc<ContractEvent, ContractState> {
  final ContractRepository contractRepository;

  ContractBloc(this.contractRepository) : super(ContractInitial()) {
    on<CreateContract>(_onCreateContract);
    on<LoadContractsByUser>(_onLoadContractsByUser);
    on<MarkContractAsCompleted>(_onMarkContractAsCompleted);
    on<MarkContractInvalidOrValid>(_onMarkContractInvalidOrValid);
  }

  Future<void> _onCreateContract(
    CreateContract event,
    Emitter<ContractState> emit,
  ) async {
    try {
      final id = await contractRepository.createContract(event.contract);
      emit(ContractCreated(id: id));
    } catch (e) {
      emit(ContractError(message: e.toString()));
    }
  }

  Future<void> _onLoadContractsByUser(
    LoadContractsByUser event,
    Emitter<ContractState> emit,
  ) async {
    try {
      final contracts = await contractRepository.getContractsByUser(event.userId);
      emit(ContractsLoaded(contracts: contracts));
    } catch (e) {
      emit(ContractError(message: e.toString()));
    }
  }
  
  Future<void> _onMarkContractAsCompleted(
    MarkContractAsCompleted event,
    Emitter<ContractState> emit,
  ) async {
    try {
      final currentState = state;
      if (currentState is ContractsLoaded) {
        final updatedContracts = currentState.contracts.map((contract) {
          if (contract.id == event.contractId) {
            return contract.copyWithCompleted(isCompleted: true);
          }
          return contract;
        }).toList();

        await contractRepository.updateContract(updatedContracts.firstWhere((contract) => contract.id == event.contractId));
        emit(ContractsLoaded(contracts: updatedContracts));
      }
    } catch (e) {
      emit(ContractError(message: e.toString()));
    }
  }

  Future<void> _onMarkContractInvalidOrValid(
    MarkContractInvalidOrValid event,
    Emitter<ContractState> emit,
  ) async {
    try {
      final currentState = state;
      if (currentState is ContractsLoaded) {
        final updatedContracts = currentState.contracts.map((contract) {
          if (contract.id == event.contractId) {
            return contract.copyWithIsValid(isValid: event.isValid);
          }
          return contract;
        }).toList();

        await contractRepository.updateContract(updatedContracts.firstWhere((contract) => contract.id == event.contractId));
        emit(ContractsLoaded(contracts: updatedContracts));
      }
    } catch (e) {
      emit(ContractError(message: e.toString()));
    }
  }
}
