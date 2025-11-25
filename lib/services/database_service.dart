import '../models/employee.dart';

/// Database service for local storage operations
/// Currently uses in-memory storage, can be extended to use SQLite
class DatabaseService {
  // In-memory storage for demo purposes
  // In production, use sqflite for persistent storage
  final List<Employee> _employees = [];

  // Singleton pattern
  static final DatabaseService _instance = DatabaseService._internal();

  factory DatabaseService() => _instance;

  DatabaseService._internal();

  // Employee operations
  Future<List<Employee>> getEmployees() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 300));
    return List.from(_employees);
  }

  Future<Employee?> getEmployee(String id) async {
    await Future.delayed(const Duration(milliseconds: 100));
    try {
      return _employees.firstWhere((e) => e.id == id);
    } catch (e) {
      return null;
    }
  }

  Future<void> insertEmployee(Employee employee) async {
    await Future.delayed(const Duration(milliseconds: 200));
    _employees.add(employee);
  }

  Future<void> updateEmployee(Employee employee) async {
    await Future.delayed(const Duration(milliseconds: 200));
    final index = _employees.indexWhere((e) => e.id == employee.id);
    if (index != -1) {
      _employees[index] = employee;
    }
  }

  Future<void> deleteEmployee(String id) async {
    await Future.delayed(const Duration(milliseconds: 200));
    _employees.removeWhere((e) => e.id == id);
  }

  Future<int> getEmployeeCount() async {
    return _employees.length;
  }

  // Search employees
  Future<List<Employee>> searchEmployees(String query) async {
    if (query.isEmpty) return _employees;
    final lowerQuery = query.toLowerCase();
    return _employees.where((e) {
      return e.name.toLowerCase().contains(lowerQuery) ||
          e.employeeId.toLowerCase().contains(lowerQuery) ||
          e.department.toLowerCase().contains(lowerQuery);
    }).toList();
  }

  // Get employees by department
  Future<List<Employee>> getEmployeesByDepartment(String department) async {
    return _employees.where((e) => e.department == department).toList();
  }

  // Clear all data
  Future<void> clearAll() async {
    _employees.clear();
  }
}
