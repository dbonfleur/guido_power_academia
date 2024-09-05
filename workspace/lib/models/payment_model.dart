class Payment {
  final int? id;
  final int contractId;
  final int value;
  final String paymentMethod;
  final int numberOfParcel;
  final DateTime dueDate;
  final DateTime updatedAt;
  final bool wasPaid;

  Payment({
    this.id,
    required this.contractId,
    required this.value,
    required this.paymentMethod,
    required this.numberOfParcel,
    required this.dueDate,
    required this.updatedAt,
    required this.wasPaid,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'contractId': contractId,
      'value': value,
      'paymentMethod': paymentMethod,
      'numberOfParcel': numberOfParcel,
      'dueDate': dueDate.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'wasPaid': wasPaid ? 1 : 0,
    };
  }

  static Payment fromMap(Map<String, Object?> map) {
    return Payment(
      id: map['id'] as int?,
      contractId: map['contractId'] as int,
      value: map['value'] as int,
      paymentMethod: map['paymentMethod'] as String,
      numberOfParcel: map['numberOfParcel'] as int,
      dueDate: DateTime.parse(map['dueDate'] as String),
      updatedAt: DateTime.parse(map['updatedAt'] as String),
      wasPaid: map['wasPaid'] == 1,
    );
  }

  Payment copyWithPaymentMethod({required String paymentMethod}) {
    return Payment(
      id: id,
      contractId: contractId,
      value: value,
      paymentMethod: paymentMethod,
      numberOfParcel: numberOfParcel,
      dueDate: dueDate,
      updatedAt: updatedAt,
      wasPaid: wasPaid,
    );
  }

  Payment copyWithWasPaidUpdatedAt({required bool wasPaid, required DateTime updatedAt}) {
    return Payment(
      id: id,
      contractId: contractId,
      value: value,
      paymentMethod: paymentMethod,
      numberOfParcel: numberOfParcel,
      dueDate: dueDate,
      updatedAt: updatedAt,
      wasPaid: wasPaid,
    );
  }
}