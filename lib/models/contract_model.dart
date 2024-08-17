class Contract {
  final int? id;
  final int userId;
  final int contractDurationMonths;
  final DateTime createdAt;
  final bool isValid;

  Contract({
    this.id,
    required this.userId,
    required this.contractDurationMonths,
    required this.createdAt,
    required this.isValid,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Contract &&
        other.id == id &&
        other.userId == userId &&
        other.contractDurationMonths == contractDurationMonths &&
        other.createdAt == createdAt &&
        other.isValid == isValid;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        userId.hashCode ^
        contractDurationMonths.hashCode ^
        createdAt.hashCode ^
        isValid.hashCode;
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'contractDurationMonths': contractDurationMonths,
      'createdAt': createdAt.toIso8601String(),
      'isValid': isValid ? 1 : 0,
    };
  }

  static Contract fromMap(Map<String, Object?> map) {
    return Contract(
      id: map['id'] as int?,
      userId: map['userId'] as int,
      contractDurationMonths: map['contractDurationMonths'] as int,
      createdAt: DateTime.parse(map['createdAt'] as String),
      isValid: map['isValid'] == 1,
    );
  }
}
