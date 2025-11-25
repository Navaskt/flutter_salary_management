import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_salary_management/models/employee.dart';
import 'package:flutter_salary_management/models/salary.dart';
import 'package:flutter_salary_management/models/deduction.dart';
import 'package:flutter_salary_management/models/payment_history.dart';
import 'package:flutter_salary_management/utils/validators.dart';
import 'package:flutter_salary_management/utils/formatters.dart';

void main() {
  group('Employee Model Tests', () {
    test('Create employee from JSON', () {
      final json = {
        'id': '1',
        'name': 'John Doe',
        'employeeId': 'EMP001',
        'email': 'john@example.com',
        'phone': '555-0101',
        'department': 'Engineering',
        'designation': 'Senior Developer',
        'dateOfJoining': '2020-01-15T00:00:00.000Z',
        'bankAccountNumber': '1234567890',
        'bankName': 'Chase Bank',
        'ifscCode': 'CHAS0001234',
        'basicSalary': 8500.0,
        'isActive': true,
      };

      final employee = Employee.fromJson(json);

      expect(employee.name, 'John Doe');
      expect(employee.employeeId, 'EMP001');
      expect(employee.basicSalary, 8500.0);
      expect(employee.isActive, true);
    });

    test('Convert employee to JSON', () {
      final employee = Employee(
        id: '1',
        name: 'John Doe',
        employeeId: 'EMP001',
        email: 'john@example.com',
        phone: '555-0101',
        department: 'Engineering',
        designation: 'Senior Developer',
        dateOfJoining: DateTime(2020, 1, 15),
        bankAccountNumber: '1234567890',
        bankName: 'Chase Bank',
        ifscCode: 'CHAS0001234',
        basicSalary: 8500.0,
      );

      final json = employee.toJson();

      expect(json['name'], 'John Doe');
      expect(json['basicSalary'], 8500.0);
    });

    test('Employee copyWith', () {
      final employee = Employee(
        id: '1',
        name: 'John Doe',
        employeeId: 'EMP001',
        email: 'john@example.com',
        phone: '555-0101',
        department: 'Engineering',
        designation: 'Senior Developer',
        dateOfJoining: DateTime(2020, 1, 15),
        bankAccountNumber: '1234567890',
        bankName: 'Chase Bank',
        ifscCode: 'CHAS0001234',
        basicSalary: 8500.0,
      );

      final updated = employee.copyWith(name: 'Jane Doe', basicSalary: 9000.0);

      expect(updated.name, 'Jane Doe');
      expect(updated.basicSalary, 9000.0);
      expect(updated.employeeId, 'EMP001'); // Unchanged
    });
  });

  group('Salary Model Tests', () {
    test('Calculate salary from basic', () {
      final salary = Salary.calculateFromBasic(
        id: 'sal_1',
        employeeId: 'emp_1',
        basicSalary: 5000.0,
        month: DateTime(2024, 1, 1),
        hraRate: 40.0,
        daRate: 12.0,
        taRate: 10.0,
        medicalRate: 5.0,
        pfRate: 12.0,
        taxRate: 10.0,
      );

      // HRA = 5000 * 40% = 2000
      expect(salary.hra, 2000.0);
      // DA = 5000 * 12% = 600
      expect(salary.da, 600.0);
      // TA = 5000 * 10% = 500
      expect(salary.ta, 500.0);
      // Medical = 5000 * 5% = 250
      expect(salary.medicalAllowance, 250.0);
      // Gross = 5000 + 2000 + 600 + 500 + 250 = 8350
      expect(salary.grossSalary, 8350.0);
    });

    test('Net salary calculation', () {
      final deductions = [
        Deduction(id: '1', name: 'PF', amount: 600.0, type: DeductionType.pf),
        Deduction(id: '2', name: 'Tax', amount: 835.0, type: DeductionType.tax),
      ];

      final salary = Salary(
        id: 'sal_1',
        employeeId: 'emp_1',
        basicSalary: 5000.0,
        hra: 2000.0,
        da: 600.0,
        ta: 500.0,
        medicalAllowance: 250.0,
        deductions: deductions,
        month: DateTime(2024, 1, 1),
      );

      expect(salary.grossSalary, 8350.0);
      expect(salary.totalDeductions, 1435.0);
      expect(salary.netSalary, 6915.0);
    });
  });

  group('Deduction Model Tests', () {
    test('Create deduction from JSON', () {
      final json = {
        'id': '1',
        'name': 'Provident Fund',
        'amount': 600.0,
        'type': 'pf',
      };

      final deduction = Deduction.fromJson(json);

      expect(deduction.name, 'Provident Fund');
      expect(deduction.amount, 600.0);
      expect(deduction.type, DeductionType.pf);
    });

    test('Deduction type display name', () {
      final deduction = Deduction(
        id: '1',
        name: 'PF',
        amount: 600.0,
        type: DeductionType.pf,
      );

      expect(deduction.typeDisplayName, 'Provident Fund');
    });
  });

  group('Payment History Model Tests', () {
    test('Create payment from JSON', () {
      final json = {
        'id': '1',
        'employeeId': 'emp_1',
        'employeeName': 'John Doe',
        'amount': 6915.0,
        'paymentDate': '2024-01-28T00:00:00.000Z',
        'salaryMonth': '2024-01-01T00:00:00.000Z',
        'status': 'paid',
      };

      final payment = PaymentHistory.fromJson(json);

      expect(payment.employeeName, 'John Doe');
      expect(payment.amount, 6915.0);
      expect(payment.status, PaymentStatus.paid);
    });

    test('Payment status display name', () {
      final payment = PaymentHistory(
        id: '1',
        employeeId: 'emp_1',
        employeeName: 'John Doe',
        amount: 6915.0,
        paymentDate: DateTime(2024, 1, 28),
        salaryMonth: DateTime(2024, 1, 1),
        status: PaymentStatus.pending,
      );

      expect(payment.statusDisplayName, 'Pending');
    });
  });

  group('Validators Tests', () {
    test('Email validation', () {
      expect(Validators.validateEmail('test@example.com'), null);
      expect(Validators.validateEmail('invalid-email'), isNotNull);
      expect(Validators.validateEmail(''), isNotNull);
    });

    test('Phone validation', () {
      expect(Validators.validatePhone('5550101234'), null);
      expect(Validators.validatePhone('123'), isNotNull);
    });

    test('Name validation', () {
      expect(Validators.validateName('John Doe'), null);
      expect(Validators.validateName('A'), isNotNull);
      expect(Validators.validateName(''), isNotNull);
    });

    test('Salary validation', () {
      expect(Validators.validateSalary('5000'), null);
      expect(Validators.validateSalary('5,000'), null);
      expect(Validators.validateSalary('-100'), isNotNull);
      expect(Validators.validateSalary('abc'), isNotNull);
    });

    test('Parse double', () {
      expect(Validators.parseDouble('1000'), 1000.0);
      expect(Validators.parseDouble('1,000'), 1000.0);
      expect(Validators.parseDouble('invalid', 0), 0.0);
    });
  });

  group('Formatters Tests', () {
    test('Format currency', () {
      final result = Formatters.formatCurrency(1234.56);
      expect(result, contains('1,234.56'));
    });

    test('Format compact currency', () {
      final result = Formatters.formatCompactCurrency(1500000);
      expect(result.contains('M') || result.contains('1.5'), true);
    });

    test('Get initials', () {
      expect(Formatters.getInitials('John Doe'), 'JD');
      expect(Formatters.getInitials('Alice'), 'A');
      expect(Formatters.getInitials('John Michael Doe'), 'JD');
    });

    test('Mask bank account', () {
      expect(Formatters.maskBankAccount('1234567890'), '******7890');
      expect(Formatters.maskBankAccount('1234'), '1234');
    });
  });
}
