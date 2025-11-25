import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import '../models/employee.dart';
import '../models/salary.dart';
import '../providers/salary_provider.dart';
import '../services/pdf_service.dart';
import '../utils/formatters.dart';
import '../widgets/deduction_item.dart';
import '../config/theme.dart';

class PayslipScreen extends StatelessWidget {
  final Employee employee;
  final Salary salary;

  const PayslipScreen({
    super.key,
    required this.employee,
    required this.salary,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payslip'),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () => _sharePayslip(context),
          ),
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: () => _downloadPdf(context),
          ),
        ],
      ),
      body: Consumer<SalaryProvider>(
        builder: (context, provider, child) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Company Header
                _buildCompanyHeader(context, provider),
                const SizedBox(height: 24),

                // Payslip Title
                Center(
                  child: Column(
                    children: [
                      Text(
                        'SALARY SLIP',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              letterSpacing: 2,
                            ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'For the month of ${Formatters.formatMonthYear(salary.month)}',
                        style: TextStyle(
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Employee Details
                _buildEmployeeDetails(context),
                const SizedBox(height: 24),

                // Earnings
                _buildEarningsSection(context),
                const SizedBox(height: 16),

                // Deductions
                _buildDeductionsSection(context),
                const SizedBox(height: 24),

                // Net Salary
                _buildNetSalary(context),
                const SizedBox(height: 32),

                // Signature Section
                _buildSignatureSection(context),
                const SizedBox(height: 16),

                // Footer
                Center(
                  child: Text(
                    'This is a computer-generated document',
                    style: TextStyle(
                      color: Colors.grey[500],
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () => _sharePayslip(context),
                icon: const Icon(Icons.share),
                label: const Text('Share'),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () => _downloadPdf(context),
                icon: const Icon(Icons.download),
                label: const Text('Download PDF'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCompanyHeader(BuildContext context, SalaryProvider provider) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: AppTheme.primaryColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text(
                  provider.companyName.isNotEmpty ? provider.companyName[0] : 'C',
                  style: const TextStyle(
                    color: Colors.white,
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
                  Text(
                    provider.companyName,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '123 Business Park, Tech City',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
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

  Widget _buildEmployeeDetails(BuildContext context) {
    return Card(
      color: Colors.grey[50],
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: _buildDetailItem('Employee Name', employee.name),
                ),
                Expanded(
                  child: _buildDetailItem('Employee ID', employee.employeeId),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildDetailItem('Department', employee.department),
                ),
                Expanded(
                  child: _buildDetailItem('Designation', employee.designation),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildDetailItem(
                    'Date of Joining',
                    Formatters.formatDate(employee.dateOfJoining),
                  ),
                ),
                Expanded(
                  child: _buildDetailItem(
                    'Bank Account',
                    Formatters.maskBankAccount(employee.bankAccountNumber),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 11,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 13,
          ),
        ),
      ],
    );
  }

  Widget _buildEarningsSection(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.green.withAlpha(25),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(Icons.add_circle, color: Colors.green[700], size: 20),
                ),
                const SizedBox(width: 12),
                Text(
                  'EARNINGS',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.green[700],
                      ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildAmountRow('Basic Salary', salary.basicSalary),
            _buildAmountRow('HRA', salary.hra),
            _buildAmountRow('DA', salary.da),
            _buildAmountRow('TA', salary.ta),
            _buildAmountRow('Medical Allowance', salary.medicalAllowance),
            if (salary.specialAllowance > 0)
              _buildAmountRow('Special Allowance', salary.specialAllowance),
            if (salary.otherAllowances > 0)
              _buildAmountRow('Other Allowances', salary.otherAllowances),
            const Divider(height: 24),
            _buildAmountRow(
              'Total Earnings',
              salary.grossSalary,
              isBold: true,
              color: Colors.green[700],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDeductionsSection(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.red.withAlpha(25),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(Icons.remove_circle, color: Colors.red[700], size: 20),
                ),
                const SizedBox(width: 12),
                Text(
                  'DEDUCTIONS',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.red[700],
                      ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...salary.deductions.map(
              (d) => _buildAmountRow(d.name, d.amount, isDeduction: true),
            ),
            const Divider(height: 24),
            _buildAmountRow(
              'Total Deductions',
              salary.totalDeductions,
              isBold: true,
              isDeduction: true,
              color: Colors.red[700],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAmountRow(
    String label,
    double amount, {
    bool isBold = false,
    bool isDeduction = false,
    Color? color,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              color: color,
            ),
          ),
          Text(
            '${isDeduction ? '- ' : ''}${Formatters.formatCurrency(amount)}',
            style: TextStyle(
              fontWeight: isBold ? FontWeight.bold : FontWeight.w500,
              color: color ?? (isDeduction ? Colors.red[700] : Colors.green[700]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNetSalary(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppTheme.primaryColor, AppTheme.primaryDark],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'NET SALARY',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 12,
                  letterSpacing: 1,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Take Home Pay',
                style: TextStyle(
                  color: Colors.white54,
                  fontSize: 11,
                ),
              ),
            ],
          ),
          Text(
            Formatters.formatCurrency(salary.netSalary),
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 28,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSignatureSection(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            children: [
              const SizedBox(height: 40),
              Container(
                height: 1,
                color: Colors.grey[400],
              ),
              const SizedBox(height: 8),
              Text(
                'Employee Signature',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 40),
        Expanded(
          child: Column(
            children: [
              const SizedBox(height: 40),
              Container(
                height: 1,
                color: Colors.grey[400],
              ),
              const SizedBox(height: 8),
              Text(
                'Authorized Signature',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _sharePayslip(BuildContext context) async {
    final provider = context.read<SalaryProvider>();
    final pdfService = PdfService();

    try {
      final pdfBytes = await pdfService.generatePayslip(
        employee: employee,
        salary: salary,
        companyName: provider.companyName,
        companyAddress: '123 Business Park, Tech City',
      );

      final fileName =
          'Payslip_${employee.name.replaceAll(' ', '_')}_${Formatters.formatMonth(salary.month).replaceAll(' ', '_')}.pdf';

      final filePath = await pdfService.savePdfToFile(pdfBytes, fileName);

      await Share.shareXFiles(
        [XFile(filePath)],
        subject: 'Payslip - ${employee.name} - ${Formatters.formatMonthYear(salary.month)}',
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error sharing payslip: $e')),
      );
    }
  }

  Future<void> _downloadPdf(BuildContext context) async {
    final provider = context.read<SalaryProvider>();
    final pdfService = PdfService();

    try {
      final pdfBytes = await pdfService.generatePayslip(
        employee: employee,
        salary: salary,
        companyName: provider.companyName,
        companyAddress: '123 Business Park, Tech City',
      );

      final fileName =
          'Payslip_${employee.name.replaceAll(' ', '_')}_${Formatters.formatMonth(salary.month).replaceAll(' ', '_')}.pdf';

      final filePath = await pdfService.savePdfToFile(pdfBytes, fileName);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Payslip saved to: $filePath'),
          action: SnackBarAction(
            label: 'Share',
            onPressed: () => _sharePayslip(context),
          ),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error generating PDF: $e')),
      );
    }
  }
}
