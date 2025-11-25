enum DeductionType {
  tax,
  pf,
  insurance,
  loan,
  other,
}

class Deduction {
  final String id;
  final String name;
  final double amount;
  final DeductionType type;
  final String? description;

  Deduction({
    required this.id,
    required this.name,
    required this.amount,
    required this.type,
    this.description,
  });

  factory Deduction.fromJson(Map<String, dynamic> json) {
    return Deduction(
      id: json['id'] as String,
      name: json['name'] as String,
      amount: (json['amount'] as num).toDouble(),
      type: DeductionType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => DeductionType.other,
      ),
      description: json['description'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'amount': amount,
      'type': type.name,
      'description': description,
    };
  }

  Deduction copyWith({
    String? id,
    String? name,
    double? amount,
    DeductionType? type,
    String? description,
  }) {
    return Deduction(
      id: id ?? this.id,
      name: name ?? this.name,
      amount: amount ?? this.amount,
      type: type ?? this.type,
      description: description ?? this.description,
    );
  }

  String get typeDisplayName {
    switch (type) {
      case DeductionType.tax:
        return 'Tax';
      case DeductionType.pf:
        return 'Provident Fund';
      case DeductionType.insurance:
        return 'Insurance';
      case DeductionType.loan:
        return 'Loan';
      case DeductionType.other:
        return 'Other';
    }
  }
}
