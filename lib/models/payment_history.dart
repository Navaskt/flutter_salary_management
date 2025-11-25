enum PaymentStatus {
  paid,
  pending,
  processing,
}

class PaymentHistory {
  final String id;
  final String employeeId;
  final String employeeName;
  final double amount;
  final DateTime paymentDate;
  final DateTime salaryMonth;
  final PaymentStatus status;
  final String? transactionId;
  final String? remarks;

  PaymentHistory({
    required this.id,
    required this.employeeId,
    required this.employeeName,
    required this.amount,
    required this.paymentDate,
    required this.salaryMonth,
    required this.status,
    this.transactionId,
    this.remarks,
  });

  factory PaymentHistory.fromJson(Map<String, dynamic> json) {
    return PaymentHistory(
      id: json['id'] as String,
      employeeId: json['employeeId'] as String,
      employeeName: json['employeeName'] as String,
      amount: (json['amount'] as num).toDouble(),
      paymentDate: DateTime.parse(json['paymentDate'] as String),
      salaryMonth: DateTime.parse(json['salaryMonth'] as String),
      status: PaymentStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => PaymentStatus.pending,
      ),
      transactionId: json['transactionId'] as String?,
      remarks: json['remarks'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'employeeId': employeeId,
      'employeeName': employeeName,
      'amount': amount,
      'paymentDate': paymentDate.toIso8601String(),
      'salaryMonth': salaryMonth.toIso8601String(),
      'status': status.name,
      'transactionId': transactionId,
      'remarks': remarks,
    };
  }

  PaymentHistory copyWith({
    String? id,
    String? employeeId,
    String? employeeName,
    double? amount,
    DateTime? paymentDate,
    DateTime? salaryMonth,
    PaymentStatus? status,
    String? transactionId,
    String? remarks,
  }) {
    return PaymentHistory(
      id: id ?? this.id,
      employeeId: employeeId ?? this.employeeId,
      employeeName: employeeName ?? this.employeeName,
      amount: amount ?? this.amount,
      paymentDate: paymentDate ?? this.paymentDate,
      salaryMonth: salaryMonth ?? this.salaryMonth,
      status: status ?? this.status,
      transactionId: transactionId ?? this.transactionId,
      remarks: remarks ?? this.remarks,
    );
  }

  String get statusDisplayName {
    switch (status) {
      case PaymentStatus.paid:
        return 'Paid';
      case PaymentStatus.pending:
        return 'Pending';
      case PaymentStatus.processing:
        return 'Processing';
    }
  }
}
