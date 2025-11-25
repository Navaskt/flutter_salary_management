import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/employee.dart';
import '../models/salary.dart';
import '../providers/salary_provider.dart';
import '../utils/formatters.dart';
import '../config/theme.dart';
import 'payslip_screen.dart';
import 'add_employee_screen.dart';

class EmployeeDetailScreen extends StatelessWidget {
  final Employee employee;

  const EmployeeDetailScreen({
    super.key,
    required this.employee,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Employee Details'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => AddEmployeeScreen(employee: employee),
                ),
              );
            },
          ),
        ],
      ),
      body: Consumer<SalaryProvider>(
        builder: (context, provider, child) {
          final salary = Salary.calculateFromBasic(
            id: 'sal_${employee.id}',
            employeeId: employee.id,
            basicSalary: employee.basicSalary,
            month: DateTime.now(),
            taxRate: 10,
          );

          final payments = provider.getPaymentsByEmployee(employee.id);

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Profile Card
                _buildProfileCard(context),
                const SizedBox(height: 16),

                // Quick Stats
                _buildQuickStats(salary),
                const SizedBox(height: 16),

                // Contact Information
                _buildInfoSection(
                  context,
                  'Contact Information',
                  Icons.contact_mail,
                  [
                    _buildInfoRow(Icons.email, 'Email', employee.email),
                    _buildInfoRow(Icons.phone, 'Phone', employee.phone),
                  ],
                ),
                const SizedBox(height: 16),

                // Employment Details
                _buildInfoSection(
                  context,
                  'Employment Details',
                  Icons.work,
                  [
                    _buildInfoRow(Icons.badge, 'Employee ID', employee.employeeId),
                    _buildInfoRow(Icons.business, 'Department', employee.department),
                    _buildInfoRow(Icons.work_outline, 'Designation', employee.designation),
                    _buildInfoRow(
                      Icons.calendar_today,
                      'Date of Joining',
                      Formatters.formatDate(employee.dateOfJoining),
                    ),
                    _buildInfoRow(
                      Icons.timer,
                      'Experience',
                      Formatters.formatDuration(
                        DateTime.now().difference(employee.dateOfJoining),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Bank Details
                _buildInfoSection(
                  context,
                  'Bank Details',
                  Icons.account_balance,
                  [
                    _buildInfoRow(
                      Icons.account_balance,
                      'Bank Name',
                      employee.bankName,
                    ),
                    _buildInfoRow(
                      Icons.credit_card,
                      'Account Number',
                      Formatters.maskBankAccount(employee.bankAccountNumber),
                    ),
                    _buildInfoRow(Icons.pin, 'IFSC Code', employee.ifscCode),
                  ],
                ),
                const SizedBox(height: 16),

                // Salary Structure
                _buildSalaryStructure(context, salary),
                const SizedBox(height: 16),

                // Recent Payments
                if (payments.isNotEmpty) ...[
                  _buildRecentPayments(context, payments),
                  const SizedBox(height: 16),
                ],

                // Action Buttons
                _buildActionButtons(context, salary),
                const SizedBox(height: 24),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildProfileCard(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withAlpha(25),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Center(
                child: Text(
                  Formatters.getInitials(employee.name),
                  style: TextStyle(
                    color: AppTheme.primaryColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 28,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          employee.name,
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: employee.isActive
                              ? AppTheme.successColor.withAlpha(25)
                              : Colors.red.withAlpha(25),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          employee.isActive ? 'Active' : 'Inactive',
                          style: TextStyle(
                            color: employee.isActive
                                ? AppTheme.successColor
                                : Colors.red,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    employee.designation,
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    employee.department,
                    style: TextStyle(
                      color: AppTheme.primaryColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickStats(Salary salary) {
    return Row(
      children: [
        Expanded(
          child: _buildStatItem(
            'Basic Salary',
            Formatters.formatCurrency(salary.basicSalary),
            AppTheme.primaryColor,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatItem(
            'Net Salary',
            Formatters.formatCurrency(salary.netSalary),
            AppTheme.successColor,
          ),
        ),
      ],
    );
  }

  Widget _buildStatItem(String label, String value, Color color) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoSection(
    BuildContext context,
    String title,
    IconData icon,
    List<Widget> children,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: AppTheme.primaryColor, size: 20),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 18, color: Colors.grey[500]),
          const SizedBox(width: 12),
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 13,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSalaryStructure(BuildContext context, Salary salary) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.account_balance_wallet, color: AppTheme.primaryColor, size: 20),
                const SizedBox(width: 8),
                Text(
                  'Salary Structure',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildSalaryRow('Basic Salary', salary.basicSalary, isEarning: true),
            _buildSalaryRow('HRA', salary.hra, isEarning: true),
            _buildSalaryRow('DA', salary.da, isEarning: true),
            _buildSalaryRow('TA', salary.ta, isEarning: true),
            _buildSalaryRow('Medical', salary.medicalAllowance, isEarning: true),
            const Divider(),
            _buildSalaryRow('Gross Salary', salary.grossSalary, isTotal: true),
            const SizedBox(height: 8),
            ...salary.deductions.map(
              (d) => _buildSalaryRow(d.name, d.amount, isEarning: false),
            ),
            const Divider(),
            _buildSalaryRow('Total Deductions', salary.totalDeductions, isTotal: true, isEarning: false),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withAlpha(25),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Net Salary',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                  Text(
                    Formatters.formatCurrency(salary.netSalary),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: AppTheme.primaryColor,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSalaryRow(
    String label,
    double amount, {
    bool isEarning = true,
    bool isTotal = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: isTotal ? FontWeight.w600 : FontWeight.normal,
              color: isTotal ? null : Colors.grey[700],
            ),
          ),
          Text(
            '${isEarning ? '+' : '-'} ${Formatters.formatCurrency(amount)}',
            style: TextStyle(
              fontWeight: isTotal ? FontWeight.w600 : FontWeight.w500,
              color: isEarning ? Colors.green : Colors.red,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentPayments(BuildContext context, List payments) {
    final recentPayments = payments.take(3).toList();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.history, color: AppTheme.primaryColor, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      'Recent Payments',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ],
                ),
                TextButton(
                  onPressed: () {},
                  child: const Text('View All'),
                ),
              ],
            ),
            const SizedBox(height: 8),
            ...recentPayments.map((payment) => ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: AppTheme.primaryColor.withAlpha(25),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.receipt,
                      color: AppTheme.primaryColor,
                      size: 20,
                    ),
                  ),
                  title: Text(Formatters.formatMonthYear(payment.salaryMonth)),
                  subtitle: Text(
                    payment.status.name.toUpperCase(),
                    style: TextStyle(
                      fontSize: 11,
                      color: payment.status.name == 'paid'
                          ? AppTheme.successColor
                          : AppTheme.warningColor,
                    ),
                  ),
                  trailing: Text(
                    Formatters.formatCurrency(payment.amount),
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                )),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context, Salary salary) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => PayslipScreen(
                    employee: employee,
                    salary: salary,
                  ),
                ),
              );
            },
            icon: const Icon(Icons.receipt_long),
            label: const Text('View Payslip'),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Salary processed successfully!')),
              );
            },
            icon: const Icon(Icons.send),
            label: const Text('Pay Salary'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
          ),
        ),
      ],
    );
  }
}
