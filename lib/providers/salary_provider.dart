import 'package:flutter/foundation.dart';
import '../models/employee.dart';
import '../models/salary.dart';
import '../models/deduction.dart';
import '../models/payment_history.dart';
import '../services/database_service.dart';

class SalaryProvider with ChangeNotifier {
  final DatabaseService _dbService = DatabaseService();

  List<Employee> _employees = [];
  List<PaymentHistory> _paymentHistory = [];
  bool _isDarkMode = false;
  bool _isLoading = false;
  String? _error;

  // Settings
  String _companyName = 'ABC Corporation';
  String _currency = 'USD';
  String _currencySymbol = '\$';

  // Getters
  List<Employee> get employees => _employees;
  List<PaymentHistory> get paymentHistory => _paymentHistory;
  bool get isDarkMode => _isDarkMode;
  bool get isLoading => _isLoading;
  String? get error => _error;
  String get companyName => _companyName;
  String get currency => _currency;
  String get currencySymbol => _currencySymbol;

  // Computed properties
  int get totalEmployees => _employees.where((e) => e.isActive).length;

  double get totalSalaryDisbursed {
    return _paymentHistory
        .where((p) => p.status == PaymentStatus.paid)
        .fold(0.0, (sum, p) => sum + p.amount);
  }

  double get averageSalary {
    if (_employees.isEmpty) return 0;
    final total =
        _employees.fold(0.0, (sum, e) => sum + e.basicSalary);
    return total / _employees.length;
  }

  int get pendingPayments {
    return _paymentHistory
        .where((p) => p.status == PaymentStatus.pending)
        .length;
  }

  double get pendingAmount {
    return _paymentHistory
        .where((p) => p.status == PaymentStatus.pending)
        .fold(0.0, (sum, p) => sum + p.amount);
  }

  SalaryProvider() {
    _loadSampleData();
  }

  void _loadSampleData() {
    _employees = _getSampleEmployees();
    _paymentHistory = _getSamplePaymentHistory();
    notifyListeners();
  }

  // Theme
  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }

  // Settings
  void updateCompanyName(String name) {
    _companyName = name;
    notifyListeners();
  }

  void updateCurrency(String currency, String symbol) {
    _currency = currency;
    _currencySymbol = symbol;
    notifyListeners();
  }

  // Employee operations
  Future<void> loadEmployees() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _employees = await _dbService.getEmployees();
    } catch (e) {
      _error = 'Failed to load employees: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addEmployee(Employee employee) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _dbService.insertEmployee(employee);
      _employees.add(employee);
    } catch (e) {
      _error = 'Failed to add employee: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateEmployee(Employee employee) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _dbService.updateEmployee(employee);
      final index = _employees.indexWhere((e) => e.id == employee.id);
      if (index != -1) {
        _employees[index] = employee;
      }
    } catch (e) {
      _error = 'Failed to update employee: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deleteEmployee(String id) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _dbService.deleteEmployee(id);
      _employees.removeWhere((e) => e.id == id);
    } catch (e) {
      _error = 'Failed to delete employee: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Employee? getEmployeeById(String id) {
    try {
      return _employees.firstWhere((e) => e.id == id);
    } catch (e) {
      return null;
    }
  }

  List<Employee> searchEmployees(String query) {
    if (query.isEmpty) return _employees;
    final lowerQuery = query.toLowerCase();
    return _employees.where((e) {
      return e.name.toLowerCase().contains(lowerQuery) ||
          e.employeeId.toLowerCase().contains(lowerQuery) ||
          e.department.toLowerCase().contains(lowerQuery) ||
          e.designation.toLowerCase().contains(lowerQuery);
    }).toList();
  }

  // Payment operations
  Future<void> addPayment(PaymentHistory payment) async {
    _paymentHistory.insert(0, payment);
    notifyListeners();
  }

  Future<void> updatePaymentStatus(String id, PaymentStatus status) async {
    final index = _paymentHistory.indexWhere((p) => p.id == id);
    if (index != -1) {
      _paymentHistory[index] = _paymentHistory[index].copyWith(status: status);
      notifyListeners();
    }
  }

  List<PaymentHistory> getPaymentsByEmployee(String employeeId) {
    return _paymentHistory.where((p) => p.employeeId == employeeId).toList();
  }

  List<PaymentHistory> getPaymentsByMonth(DateTime month) {
    return _paymentHistory.where((p) {
      return p.salaryMonth.year == month.year &&
          p.salaryMonth.month == month.month;
    }).toList();
  }

  List<PaymentHistory> getPaymentsByStatus(PaymentStatus status) {
    return _paymentHistory.where((p) => p.status == status).toList();
  }

  // Salary calculation
  Salary calculateSalary({
    required String employeeId,
    required double basicSalary,
    required DateTime month,
    double hraRate = 40.0,
    double daRate = 12.0,
    double taRate = 10.0,
    double medicalRate = 5.0,
    double pfRate = 12.0,
    double taxRate = 10.0,
  }) {
    final id = 'sal_${DateTime.now().millisecondsSinceEpoch}';
    return Salary.calculateFromBasic(
      id: id,
      employeeId: employeeId,
      basicSalary: basicSalary,
      month: month,
      hraRate: hraRate,
      daRate: daRate,
      taRate: taRate,
      medicalRate: medicalRate,
      pfRate: pfRate,
      taxRate: taxRate,
    );
  }

  // Monthly salary data for chart
  List<Map<String, dynamic>> getMonthlySalaryData() {
    final now = DateTime.now();
    final data = <Map<String, dynamic>>[];

    for (int i = 5; i >= 0; i--) {
      final month = DateTime(now.year, now.month - i, 1);
      final payments = getPaymentsByMonth(month);
      final total = payments
          .where((p) => p.status == PaymentStatus.paid)
          .fold(0.0, (sum, p) => sum + p.amount);

      data.add({
        'month': month,
        'amount': total,
      });
    }

    return data;
  }

  // Sample data
  List<Employee> _getSampleEmployees() {
    return [
      Employee(
        id: '1',
        name: 'John Smith',
        employeeId: 'EMP001',
        email: 'john.smith@company.com',
        phone: '555-0101',
        department: 'Engineering',
        designation: 'Senior Developer',
        dateOfJoining: DateTime(2020, 3, 15),
        bankAccountNumber: '1234567890',
        bankName: 'Chase Bank',
        ifscCode: 'CHAS0001234',
        basicSalary: 8500,
      ),
      Employee(
        id: '2',
        name: 'Sarah Johnson',
        employeeId: 'EMP002',
        email: 'sarah.j@company.com',
        phone: '555-0102',
        department: 'Design',
        designation: 'UX Lead',
        dateOfJoining: DateTime(2019, 7, 1),
        bankAccountNumber: '0987654321',
        bankName: 'Bank of America',
        ifscCode: 'BOFA0005678',
        basicSalary: 7500,
      ),
      Employee(
        id: '3',
        name: 'Michael Brown',
        employeeId: 'EMP003',
        email: 'michael.b@company.com',
        phone: '555-0103',
        department: 'Marketing',
        designation: 'Marketing Manager',
        dateOfJoining: DateTime(2021, 1, 10),
        bankAccountNumber: '1122334455',
        bankName: 'Wells Fargo',
        ifscCode: 'WFAR0009012',
        basicSalary: 6800,
      ),
      Employee(
        id: '4',
        name: 'Emily Davis',
        employeeId: 'EMP004',
        email: 'emily.d@company.com',
        phone: '555-0104',
        department: 'Human Resources',
        designation: 'HR Manager',
        dateOfJoining: DateTime(2018, 11, 20),
        bankAccountNumber: '5566778899',
        bankName: 'Citibank',
        ifscCode: 'CITI0003456',
        basicSalary: 7000,
      ),
      Employee(
        id: '5',
        name: 'David Wilson',
        employeeId: 'EMP005',
        email: 'david.w@company.com',
        phone: '555-0105',
        department: 'Engineering',
        designation: 'Lead Developer',
        dateOfJoining: DateTime(2017, 5, 5),
        bankAccountNumber: '2233445566',
        bankName: 'Chase Bank',
        ifscCode: 'CHAS0007890',
        basicSalary: 9500,
      ),
      Employee(
        id: '6',
        name: 'Jennifer Martinez',
        employeeId: 'EMP006',
        email: 'jennifer.m@company.com',
        phone: '555-0106',
        department: 'Finance',
        designation: 'Finance Manager',
        dateOfJoining: DateTime(2019, 9, 12),
        bankAccountNumber: '6677889900',
        bankName: 'TD Bank',
        ifscCode: 'TDBK0001234',
        basicSalary: 8000,
      ),
      Employee(
        id: '7',
        name: 'Robert Taylor',
        employeeId: 'EMP007',
        email: 'robert.t@company.com',
        phone: '555-0107',
        department: 'Sales',
        designation: 'Sales Manager',
        dateOfJoining: DateTime(2020, 6, 18),
        bankAccountNumber: '3344556677',
        bankName: 'PNC Bank',
        ifscCode: 'PNCB0005678',
        basicSalary: 7200,
      ),
      Employee(
        id: '8',
        name: 'Lisa Anderson',
        employeeId: 'EMP008',
        email: 'lisa.a@company.com',
        phone: '555-0108',
        department: 'Engineering',
        designation: 'Junior Developer',
        dateOfJoining: DateTime(2023, 2, 1),
        bankAccountNumber: '8899001122',
        bankName: 'US Bank',
        ifscCode: 'USBK0009012',
        basicSalary: 5500,
      ),
    ];
  }

  List<PaymentHistory> _getSamplePaymentHistory() {
    final now = DateTime.now();
    final payments = <PaymentHistory>[];

    // Generate payment history for last 6 months
    for (int month = 0; month < 6; month++) {
      final paymentMonth = DateTime(now.year, now.month - month, 1);

      for (final employee in _employees) {
        final salary = Salary.calculateFromBasic(
          id: 'sal_${employee.id}_$month',
          employeeId: employee.id,
          basicSalary: employee.basicSalary,
          month: paymentMonth,
          taxRate: 10,
        );

        // Assign status based on employee index for sample data
        // First employee: pending, second: processing, rest: paid for current month
        PaymentStatus status;
        if (month == 0) {
          final employeeIndex = _employees.indexOf(employee);
          if (employeeIndex == 0) {
            status = PaymentStatus.pending;
          } else if (employeeIndex == 1) {
            status = PaymentStatus.processing;
          } else {
            status = PaymentStatus.paid;
          }
        } else {
          status = PaymentStatus.paid;
        }

        payments.add(PaymentHistory(
          id: 'pay_${employee.id}_$month',
          employeeId: employee.id,
          employeeName: employee.name,
          amount: salary.netSalary,
          paymentDate: DateTime(paymentMonth.year, paymentMonth.month, 28),
          salaryMonth: paymentMonth,
          status: status,
          transactionId: status == PaymentStatus.paid
              ? 'TXN${DateTime.now().millisecondsSinceEpoch}$month'
              : null,
        ));
      }
    }

    return payments;
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
