import 'deduction.dart';

class Salary {
  final String id;
  final String employeeId;
  final double basicSalary;
  final double hra;
  final double da;
  final double ta;
  final double medicalAllowance;
  final double specialAllowance;
  final double otherAllowances;
  final List<Deduction> deductions;
  final DateTime month;

  Salary({
    required this.id,
    required this.employeeId,
    required this.basicSalary,
    this.hra = 0,
    this.da = 0,
    this.ta = 0,
    this.medicalAllowance = 0,
    this.specialAllowance = 0,
    this.otherAllowances = 0,
    this.deductions = const [],
    required this.month,
  });

  double get totalAllowances =>
      hra + da + ta + medicalAllowance + specialAllowance + otherAllowances;

  double get grossSalary => basicSalary + totalAllowances;

  double get totalDeductions =>
      deductions.fold(0.0, (sum, d) => sum + d.amount);

  double get netSalary => grossSalary - totalDeductions;

  factory Salary.fromJson(Map<String, dynamic> json) {
    return Salary(
      id: json['id'] as String,
      employeeId: json['employeeId'] as String,
      basicSalary: (json['basicSalary'] as num).toDouble(),
      hra: (json['hra'] as num?)?.toDouble() ?? 0,
      da: (json['da'] as num?)?.toDouble() ?? 0,
      ta: (json['ta'] as num?)?.toDouble() ?? 0,
      medicalAllowance: (json['medicalAllowance'] as num?)?.toDouble() ?? 0,
      specialAllowance: (json['specialAllowance'] as num?)?.toDouble() ?? 0,
      otherAllowances: (json['otherAllowances'] as num?)?.toDouble() ?? 0,
      deductions: (json['deductions'] as List<dynamic>?)
              ?.map((d) => Deduction.fromJson(d as Map<String, dynamic>))
              .toList() ??
          [],
      month: DateTime.parse(json['month'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'employeeId': employeeId,
      'basicSalary': basicSalary,
      'hra': hra,
      'da': da,
      'ta': ta,
      'medicalAllowance': medicalAllowance,
      'specialAllowance': specialAllowance,
      'otherAllowances': otherAllowances,
      'deductions': deductions.map((d) => d.toJson()).toList(),
      'month': month.toIso8601String(),
    };
  }

  Salary copyWith({
    String? id,
    String? employeeId,
    double? basicSalary,
    double? hra,
    double? da,
    double? ta,
    double? medicalAllowance,
    double? specialAllowance,
    double? otherAllowances,
    List<Deduction>? deductions,
    DateTime? month,
  }) {
    return Salary(
      id: id ?? this.id,
      employeeId: employeeId ?? this.employeeId,
      basicSalary: basicSalary ?? this.basicSalary,
      hra: hra ?? this.hra,
      da: da ?? this.da,
      ta: ta ?? this.ta,
      medicalAllowance: medicalAllowance ?? this.medicalAllowance,
      specialAllowance: specialAllowance ?? this.specialAllowance,
      otherAllowances: otherAllowances ?? this.otherAllowances,
      deductions: deductions ?? this.deductions,
      month: month ?? this.month,
    );
  }

  /// Calculate salary with default rates from basic salary
  static Salary calculateFromBasic({
    required String id,
    required String employeeId,
    required double basicSalary,
    required DateTime month,
    double hraRate = 40.0,
    double daRate = 12.0,
    double taRate = 10.0,
    double medicalRate = 5.0,
    double pfRate = 12.0,
    double insuranceRate = 2.0,
    double professionalTax = 200.0,
    double taxRate = 0.0,
  }) {
    final hra = basicSalary * hraRate / 100;
    final da = basicSalary * daRate / 100;
    final ta = basicSalary * taRate / 100;
    final medicalAllowance = basicSalary * medicalRate / 100;

    final gross = basicSalary + hra + da + ta + medicalAllowance;

    final deductions = <Deduction>[
      Deduction(
        id: '${id}_pf',
        name: 'Provident Fund',
        amount: basicSalary * pfRate / 100,
        type: DeductionType.pf,
      ),
      Deduction(
        id: '${id}_tax',
        name: 'Income Tax',
        amount: gross * taxRate / 100,
        type: DeductionType.tax,
      ),
      Deduction(
        id: '${id}_insurance',
        name: 'Insurance',
        amount: basicSalary * insuranceRate / 100,
        type: DeductionType.insurance,
      ),
      Deduction(
        id: '${id}_pt',
        name: 'Professional Tax',
        amount: professionalTax,
        type: DeductionType.other,
      ),
    ];

    return Salary(
      id: id,
      employeeId: employeeId,
      basicSalary: basicSalary,
      hra: hra,
      da: da,
      ta: ta,
      medicalAllowance: medicalAllowance,
      deductions: deductions,
      month: month,
    );
  }
}
