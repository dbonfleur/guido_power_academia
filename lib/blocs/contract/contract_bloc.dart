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
}
