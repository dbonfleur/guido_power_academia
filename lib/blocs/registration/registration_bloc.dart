import 'dart:convert';
import 'dart:io';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/contract/contract_bloc.dart';
import '../../blocs/payment/payment_bloc.dart';
import '../../blocs/user/user_bloc.dart';
import '../../models/contract_model.dart';
import '../../models/payment_model.dart';
import '../../models/user_model.dart';

part 'registration_event.dart';
part 'registration_state.dart';

class RegistrationBloc extends Bloc<RegistrationEvent, RegistrationState> {

  RegistrationBloc()
      : super(RegistrationInitial()) {
    on<RegisterUser>(_onRegisterUser);
  }

  Future<void> _onRegisterUser(
    RegisterUser event,
    Emitter<RegistrationState> emit,
  ) async {
    emit(RegistrationLoading());

    try {
      final userBloc = BlocProvider.of<UserBloc>(event.context);
      final contractBloc = BlocProvider.of<ContractBloc>(event.context);
      final paymentBloc = BlocProvider.of<PaymentBloc>(event.context);
      
      String? imageBase64;

      if (event.imageUrl != null) {
        final bytes = File(event.imageUrl!).readAsBytesSync();
        imageBase64 = base64Encode(bytes);
      }

      final user = User(
        username: event.username,
        fullName: event.fullName,
        dateOfBirth: event.dateOfBirth,
        email: event.email,
        password: User.hashPassword(event.password),
        accountType: event.accountType,
        imageUrl: imageBase64, 
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      userBloc.add(CreateUser(user: user));

      await for (final state in userBloc.stream) {
        if (state is UserCreated) {
          final createdUserId = state.id;

          final contract = Contract(
            userId: createdUserId,
            contractDurationMonths: event.contractDuration,
            createdAt: DateTime.now(),
            isValid: true,
            isCompleted: false,
          );

          contractBloc.add(CreateContract(contract: contract));

          await for (final contractState in contractBloc.stream) {
            if (contractState is ContractCreated) {
              final createdContractId = contractState.id;

              for (int i = 0; i < event.contractDuration; i++) {
                final payment = Payment(
                  contractId: createdContractId,
                  value: 150,
                  paymentMethod: event.paymentMethod,
                  numberOfParcel: i + 1,
                  dueDate: DateTime.now().add(Duration(days: 30 * (i + 1))),
                  updatedAt: DateTime.now(),
                  wasPaid: false,
                );

                paymentBloc.add(CreatePayment(payment: payment));
              }

              emit(RegistrationSuccess());
              return;
            } else if (contractState is ContractError) {
              throw Exception('Erro na criação do contrato');
            }
          }
        } else if (state is UserError) {
          throw Exception('Erro na criação do usuário');
        }
      }
    } catch (e) {
      emit(RegistrationFailure(e.toString()));
    }
  }
}
