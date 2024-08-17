part of 'payment_bloc.dart';

abstract class PaymentState extends Equatable {
  const PaymentState();

  @override
  List<Object?> get props => [];
}

class PaymentInitial extends PaymentState {}

class PaymentCreated extends PaymentState {
  final int id;

  const PaymentCreated({required this.id});

  @override
  List<Object?> get props => [id];
}

class PaymentsLoaded extends PaymentState {
  final List<Payment> payments;

  const PaymentsLoaded({required this.payments});

  @override
  List<Object?> get props => [payments];
}

class PaymentError extends PaymentState {
  final String message;

  const PaymentError({required this.message});

  @override
  List<Object?> get props => [message];
}


