class Employee {
  final String id;
  final String name;
  final String employeeId;
  final String email;
  final String phone;
  final String department;
  final String designation;
  final DateTime dateOfJoining;
  final String bankAccountNumber;
  final String bankName;
  final String ifscCode;
  final double basicSalary;
  final bool isActive;
  final String? profileImageUrl;

  Employee({
    required this.id,
    required this.name,
    required this.employeeId,
    required this.email,
    required this.phone,
    required this.department,
    required this.designation,
    required this.dateOfJoining,
    required this.bankAccountNumber,
    required this.bankName,
    required this.ifscCode,
    required this.basicSalary,
    this.isActive = true,
    this.profileImageUrl,
  });

  factory Employee.fromJson(Map<String, dynamic> json) {
    return Employee(
      id: json['id'] as String,
      name: json['name'] as String,
      employeeId: json['employeeId'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String,
      department: json['department'] as String,
      designation: json['designation'] as String,
      dateOfJoining: DateTime.parse(json['dateOfJoining'] as String),
      bankAccountNumber: json['bankAccountNumber'] as String,
      bankName: json['bankName'] as String,
      ifscCode: json['ifscCode'] as String,
      basicSalary: (json['basicSalary'] as num).toDouble(),
      isActive: json['isActive'] as bool? ?? true,
      profileImageUrl: json['profileImageUrl'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'employeeId': employeeId,
      'email': email,
      'phone': phone,
      'department': department,
      'designation': designation,
      'dateOfJoining': dateOfJoining.toIso8601String(),
      'bankAccountNumber': bankAccountNumber,
      'bankName': bankName,
      'ifscCode': ifscCode,
      'basicSalary': basicSalary,
      'isActive': isActive,
      'profileImageUrl': profileImageUrl,
    };
  }

  Employee copyWith({
    String? id,
    String? name,
    String? employeeId,
    String? email,
    String? phone,
    String? department,
    String? designation,
    DateTime? dateOfJoining,
    String? bankAccountNumber,
    String? bankName,
    String? ifscCode,
    double? basicSalary,
    bool? isActive,
    String? profileImageUrl,
  }) {
    return Employee(
      id: id ?? this.id,
      name: name ?? this.name,
      employeeId: employeeId ?? this.employeeId,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      department: department ?? this.department,
      designation: designation ?? this.designation,
      dateOfJoining: dateOfJoining ?? this.dateOfJoining,
      bankAccountNumber: bankAccountNumber ?? this.bankAccountNumber,
      bankName: bankName ?? this.bankName,
      ifscCode: ifscCode ?? this.ifscCode,
      basicSalary: basicSalary ?? this.basicSalary,
      isActive: isActive ?? this.isActive,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
    );
  }

  int get yearsOfService {
    return DateTime.now().difference(dateOfJoining).inDays ~/ 365;
  }

  @override
  String toString() {
    return 'Employee(id: $id, name: $name, employeeId: $employeeId)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Employee && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
