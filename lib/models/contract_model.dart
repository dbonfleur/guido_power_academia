class Contract {
  final int? id;
  final int userId;
  final int contractDurationMonths;
  final DateTime createdAt;
  final bool isValid;
  final bool isCompleted;

  Contract({
    this.id,
    required this.userId,
    required this.contractDurationMonths,
    required this.createdAt,
    required this.isValid,
    required this.isCompleted,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Contract &&
        other.id == id &&
        other.userId == userId &&
        other.contractDurationMonths == contractDurationMonths &&
        other.createdAt == createdAt &&
        other.isValid == isValid &&
        other.isCompleted == isCompleted;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        userId.hashCode ^
        contractDurationMonths.hashCode ^
        createdAt.hashCode ^
        isValid.hashCode ^
        isCompleted.hashCode;
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'contractDurationMonths': contractDurationMonths,
      'createdAt': createdAt.toIso8601String(),
      'isValid': isValid ? 1 : 0,
      'isCompleted': isCompleted ? 1 : 0,
    };
  }

  static Contract fromMap(Map<String, Object?> map) {
    return Contract(
      id: map['id'] as int?,
      userId: map['userId'] as int,
      contractDurationMonths: map['contractDurationMonths'] as int,
      createdAt: DateTime.parse(map['createdAt'] as String),
      isValid: map['isValid'] == 1,
      isCompleted: map['isCompleted'] == 1,
    );
  }

  Contract copyWithContract({required bool isCompleted}) {
    return Contract(
      id: id,
      userId: userId,
      contractDurationMonths: contractDurationMonths,
      createdAt: createdAt,
      isValid: isValid,
      isCompleted: isCompleted,
    );
  }
}
