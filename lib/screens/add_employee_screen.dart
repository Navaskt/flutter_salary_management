import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/employee.dart';
import '../providers/salary_provider.dart';
import '../utils/validators.dart';
import '../config/constants.dart';
import '../widgets/custom_button.dart';

class AddEmployeeScreen extends StatefulWidget {
  final Employee? employee;

  const AddEmployeeScreen({super.key, this.employee});

  @override
  State<AddEmployeeScreen> createState() => _AddEmployeeScreenState();
}

class _AddEmployeeScreenState extends State<AddEmployeeScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  // Controllers
  late TextEditingController _nameController;
  late TextEditingController _employeeIdController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _bankAccountController;
  late TextEditingController _bankNameController;
  late TextEditingController _ifscController;
  late TextEditingController _basicSalaryController;

  String _selectedDepartment = AppConstants.departments.first;
  String _selectedDesignation = AppConstants.designations.first;
  DateTime _dateOfJoining = DateTime.now();
  bool _isActive = true;

  bool get isEditing => widget.employee != null;

  @override
  void initState() {
    super.initState();
    final employee = widget.employee;

    _nameController = TextEditingController(text: employee?.name ?? '');
    _employeeIdController = TextEditingController(text: employee?.employeeId ?? '');
    _emailController = TextEditingController(text: employee?.email ?? '');
    _phoneController = TextEditingController(text: employee?.phone ?? '');
    _bankAccountController = TextEditingController(text: employee?.bankAccountNumber ?? '');
    _bankNameController = TextEditingController(text: employee?.bankName ?? '');
    _ifscController = TextEditingController(text: employee?.ifscCode ?? '');
    _basicSalaryController = TextEditingController(
      text: employee?.basicSalary.toString() ?? '',
    );

    if (employee != null) {
      _selectedDepartment = employee.department;
      _selectedDesignation = employee.designation;
      _dateOfJoining = employee.dateOfJoining;
      _isActive = employee.isActive;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _employeeIdController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _bankAccountController.dispose();
    _bankNameController.dispose();
    _ifscController.dispose();
    _basicSalaryController.dispose();
    super.dispose();
  }

  Future<void> _saveEmployee() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final provider = context.read<SalaryProvider>();

      final employee = Employee(
        id: widget.employee?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
        name: _nameController.text.trim(),
        employeeId: _employeeIdController.text.trim(),
        email: _emailController.text.trim(),
        phone: _phoneController.text.trim(),
        department: _selectedDepartment,
        designation: _selectedDesignation,
        dateOfJoining: _dateOfJoining,
        bankAccountNumber: _bankAccountController.text.trim(),
        bankName: _bankNameController.text.trim(),
        ifscCode: _ifscController.text.trim().toUpperCase(),
        basicSalary: double.parse(_basicSalaryController.text.trim()),
        isActive: _isActive,
      );

      if (isEditing) {
        await provider.updateEmployee(employee);
      } else {
        await provider.addEmployee(employee);
      }

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              isEditing
                  ? 'Employee updated successfully'
                  : 'Employee added successfully',
            ),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Employee' : 'Add Employee'),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Personal Information
              _buildSectionTitle('Personal Information'),
              const SizedBox(height: 12),
              _buildCard([
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Full Name *',
                    prefixIcon: Icon(Icons.person),
                  ),
                  validator: Validators.validateName,
                  textCapitalization: TextCapitalization.words,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _employeeIdController,
                  decoration: const InputDecoration(
                    labelText: 'Employee ID *',
                    prefixIcon: Icon(Icons.badge),
                  ),
                  validator: Validators.validateEmployeeId,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email *',
                    prefixIcon: Icon(Icons.email),
                  ),
                  validator: Validators.validateEmail,
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _phoneController,
                  decoration: const InputDecoration(
                    labelText: 'Phone *',
                    prefixIcon: Icon(Icons.phone),
                  ),
                  validator: Validators.validatePhone,
                  keyboardType: TextInputType.phone,
                ),
              ]),
              const SizedBox(height: 24),

              // Employment Details
              _buildSectionTitle('Employment Details'),
              const SizedBox(height: 12),
              _buildCard([
                DropdownButtonFormField<String>(
                  value: _selectedDepartment,
                  decoration: const InputDecoration(
                    labelText: 'Department *',
                    prefixIcon: Icon(Icons.business),
                  ),
                  items: AppConstants.departments.map((dept) {
                    return DropdownMenuItem(value: dept, child: Text(dept));
                  }).toList(),
                  onChanged: (value) {
                    setState(() => _selectedDepartment = value!);
                  },
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: _selectedDesignation,
                  decoration: const InputDecoration(
                    labelText: 'Designation *',
                    prefixIcon: Icon(Icons.work),
                  ),
                  items: AppConstants.designations.map((des) {
                    return DropdownMenuItem(value: des, child: Text(des));
                  }).toList(),
                  onChanged: (value) {
                    setState(() => _selectedDesignation = value!);
                  },
                ),
                const SizedBox(height: 16),
                InkWell(
                  onTap: () => _selectDate(context),
                  child: InputDecorator(
                    decoration: const InputDecoration(
                      labelText: 'Date of Joining *',
                      prefixIcon: Icon(Icons.calendar_today),
                    ),
                    child: Text(
                      '${_dateOfJoining.day}/${_dateOfJoining.month}/${_dateOfJoining.year}',
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                SwitchListTile(
                  title: const Text('Active Employee'),
                  subtitle: const Text('Uncheck if employee has left'),
                  value: _isActive,
                  onChanged: (value) {
                    setState(() => _isActive = value);
                  },
                ),
              ]),
              const SizedBox(height: 24),

              // Bank Details
              _buildSectionTitle('Bank Details'),
              const SizedBox(height: 12),
              _buildCard([
                TextFormField(
                  controller: _bankNameController,
                  decoration: const InputDecoration(
                    labelText: 'Bank Name *',
                    prefixIcon: Icon(Icons.account_balance),
                  ),
                  validator: (v) => Validators.validateRequired(v, 'Bank name'),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _bankAccountController,
                  decoration: const InputDecoration(
                    labelText: 'Account Number *',
                    prefixIcon: Icon(Icons.credit_card),
                  ),
                  validator: Validators.validateBankAccount,
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _ifscController,
                  decoration: const InputDecoration(
                    labelText: 'IFSC Code *',
                    prefixIcon: Icon(Icons.pin),
                  ),
                  validator: Validators.validateIfscCode,
                  textCapitalization: TextCapitalization.characters,
                ),
              ]),
              const SizedBox(height: 24),

              // Salary Information
              _buildSectionTitle('Salary Information'),
              const SizedBox(height: 12),
              _buildCard([
                TextFormField(
                  controller: _basicSalaryController,
                  decoration: const InputDecoration(
                    labelText: 'Basic Salary *',
                    prefixIcon: Icon(Icons.attach_money),
                    prefixText: '\$ ',
                  ),
                  validator: Validators.validateSalary,
                  keyboardType: TextInputType.number,
                ),
              ]),
              const SizedBox(height: 32),

              // Submit Button
              CustomButton(
                text: isEditing ? 'Update Employee' : 'Add Employee',
                onPressed: _saveEmployee,
                isLoading: _isLoading,
                icon: isEditing ? Icons.save : Icons.person_add,
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
    );
  }

  Widget _buildCard(List<Widget> children) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: children,
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _dateOfJoining,
      firstDate: DateTime(1990),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _dateOfJoining) {
      setState(() => _dateOfJoining = picked);
    }
  }
}
