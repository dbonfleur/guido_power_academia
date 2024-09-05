part of 'payment_bloc.dart';

abstract class PaymentEvent extends Equatable {
  const PaymentEvent();

  @override
  List<Object?> get props => [];
}

class CreatePayment extends PaymentEvent {
  final Payment payment;

  const CreatePayment({required this.payment});

  @override
  List<Object?> get props => [payment];
}

class LoadPaymentsByContract extends PaymentEvent {
  final int contractId;
  final BuildContext context;

  const LoadPaymentsByContract({required this.contractId, required this.context});

  @override
  List<Object?> get props => [contractId];
}

class UpdatePaymentMethod extends PaymentEvent {
  final int paymentId;
  final String paymentMethod;

  const UpdatePaymentMethod({required this.paymentId, required this.paymentMethod});

  @override
  List<Object?> get props => [paymentId, paymentMethod];
}

class MarkPaymentAsPaid extends PaymentEvent {
  final int paymentId;
  final BuildContext context;

  const MarkPaymentAsPaid({required this.paymentId, required this.context});

  @override
  List<Object?> get props => [paymentId];
}
