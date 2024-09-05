import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/payment_model.dart';
import '../../repositories/payment_repository.dart';
import '../contract/contract_bloc.dart';

part 'payment_event.dart';
part 'payment_state.dart';

class PaymentBloc extends Bloc<PaymentEvent, PaymentState> {
  final PaymentRepository paymentRepository;

  PaymentBloc(this.paymentRepository) : super(PaymentInitial()) {
    on<CreatePayment>(_onCreatePayment);
    on<LoadPaymentsByContract>(_onLoadPaymentsByContract);
    on<UpdatePaymentMethod>(_onUpdatePaymentMethod);
    on<MarkPaymentAsPaid>(_onMarkPaymentAsPaid);
  }

  Future<void> _onCreatePayment(
    CreatePayment event,
    Emitter<PaymentState> emit,
  ) async {
    try {
      final id = await paymentRepository.createPayment(event.payment);
      emit(PaymentCreated(id: id));
    } catch (e) {
      emit(PaymentError(message: e.toString()));
    }
  }

  Future<void> _onLoadPaymentsByContract(
    LoadPaymentsByContract event,
    Emitter<PaymentState> emit,
  ) async {
    try {
      final contractBloc = BlocProvider.of<ContractBloc>(event.context);
      final payments = await paymentRepository.getPaymentsByContract(event.contractId);
      emit(PaymentsLoaded(payments: payments));

      final allPaid = payments.every((payment) => payment.wasPaid);
      if (allPaid) {
        contractBloc.add(MarkContractAsCompleted(contractId: event.contractId));
      }
    } catch (e) {
      emit(PaymentError(message: e.toString()));
    }
  }

  Future<void> _onUpdatePaymentMethod(
    UpdatePaymentMethod event,
    Emitter<PaymentState> emit,
  ) async {
    try {
      final currentState = state;
      if (currentState is PaymentsLoaded) {
        final updatedPayments = currentState.payments.map((payment) {
          if (payment.id == event.paymentId) {
            return payment.copyWithPaymentMethod(paymentMethod: event.paymentMethod);
          }
          return payment;
        }).toList();

        await paymentRepository.updatePayment(updatedPayments.firstWhere((payment) => payment.id == event.paymentId));
        emit(PaymentsLoaded(payments: updatedPayments));
      }
    } catch (e) {
      emit(PaymentError(message: e.toString()));
    }
  }

  Future<void> _onMarkPaymentAsPaid(
    MarkPaymentAsPaid event,
    Emitter<PaymentState> emit,
  ) async {
    try {
      final contractBloc = BlocProvider.of<ContractBloc>(event.context);
      final currentState = state;
      if (currentState is PaymentsLoaded) {
        final updatedPayments = currentState.payments.map((payment) {
          if (payment.id == event.paymentId) {
            return payment.copyWithWasPaidUpdatedAt(wasPaid: true, updatedAt: DateTime.now());
          }
          return payment;
        }).toList();

        await paymentRepository.updatePayment(updatedPayments.firstWhere((payment) => payment.id == event.paymentId));
        emit(PaymentsLoaded(payments: updatedPayments));

        final allPaid = updatedPayments.every((payment) => payment.wasPaid);
        if (allPaid) {
          contractBloc.add(MarkContractAsCompleted(contractId: event.paymentId));
        }
      }
    } catch (e) {
      emit(PaymentError(message: e.toString()));
    }
  }
}
