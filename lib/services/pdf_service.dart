import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import '../models/employee.dart';
import '../models/salary.dart';
import '../utils/formatters.dart';

class PdfService {
  /// Generate payslip PDF
  Future<Uint8List> generatePayslip({
    required Employee employee,
    required Salary salary,
    required String companyName,
    required String companyAddress,
  }) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(40),
        build: (context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // Header
              _buildHeader(companyName, companyAddress),
              pw.SizedBox(height: 20),
              pw.Divider(thickness: 2, color: PdfColors.blue800),
              pw.SizedBox(height: 20),

              // Title
              pw.Center(
                child: pw.Text(
                  'SALARY SLIP',
                  style: pw.TextStyle(
                    fontSize: 24,
                    fontWeight: pw.FontWeight.bold,
                    color: PdfColors.blue900,
                  ),
                ),
              ),
              pw.Center(
                child: pw.Text(
                  'For the month of ${Formatters.formatMonthYear(salary.month)}',
                  style: const pw.TextStyle(
                    fontSize: 12,
                    color: PdfColors.grey700,
                  ),
                ),
              ),
              pw.SizedBox(height: 20),

              // Employee Details
              _buildEmployeeDetails(employee),
              pw.SizedBox(height: 20),

              // Earnings and Deductions
              pw.Row(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Expanded(child: _buildEarnings(salary)),
                  pw.SizedBox(width: 20),
                  pw.Expanded(child: _buildDeductions(salary)),
                ],
              ),
              pw.SizedBox(height: 20),

              // Summary
              _buildSummary(salary),
              pw.SizedBox(height: 30),

              // Footer
              _buildFooter(),
            ],
          );
        },
      ),
    );

    return pdf.save();
  }

  pw.Widget _buildHeader(String companyName, String companyAddress) {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      children: [
        pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text(
              companyName,
              style: pw.TextStyle(
                fontSize: 24,
                fontWeight: pw.FontWeight.bold,
                color: PdfColors.blue900,
              ),
            ),
            pw.SizedBox(height: 4),
            pw.Text(
              companyAddress,
              style: const pw.TextStyle(
                fontSize: 10,
                color: PdfColors.grey700,
              ),
            ),
          ],
        ),
        pw.Container(
          width: 60,
          height: 60,
          decoration: pw.BoxDecoration(
            color: PdfColors.blue800,
            borderRadius: pw.BorderRadius.circular(8),
          ),
          child: pw.Center(
            child: pw.Text(
              companyName.isNotEmpty ? companyName[0] : 'C',
              style: pw.TextStyle(
                fontSize: 30,
                fontWeight: pw.FontWeight.bold,
                color: PdfColors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }

  pw.Widget _buildEmployeeDetails(Employee employee) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(16),
      decoration: pw.BoxDecoration(
        color: PdfColors.grey100,
        borderRadius: pw.BorderRadius.circular(8),
      ),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              _buildDetailRow('Employee Name', employee.name),
              _buildDetailRow('Employee ID', employee.employeeId),
              _buildDetailRow('Department', employee.department),
            ],
          ),
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              _buildDetailRow('Designation', employee.designation),
              _buildDetailRow(
                  'Date of Joining', Formatters.formatDate(employee.dateOfJoining)),
              _buildDetailRow('Bank Account',
                  Formatters.maskBankAccount(employee.bankAccountNumber)),
            ],
          ),
        ],
      ),
    );
  }

  pw.Widget _buildDetailRow(String label, String value) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 2),
      child: pw.Row(
        children: [
          pw.SizedBox(
            width: 100,
            child: pw.Text(
              '$label:',
              style: pw.TextStyle(
                fontSize: 10,
                fontWeight: pw.FontWeight.bold,
                color: PdfColors.grey700,
              ),
            ),
          ),
          pw.Text(
            value,
            style: const pw.TextStyle(fontSize: 10),
          ),
        ],
      ),
    );
  }

  pw.Widget _buildEarnings(Salary salary) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(12),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.green700),
        borderRadius: pw.BorderRadius.circular(8),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            'EARNINGS',
            style: pw.TextStyle(
              fontSize: 14,
              fontWeight: pw.FontWeight.bold,
              color: PdfColors.green800,
            ),
          ),
          pw.Divider(color: PdfColors.green300),
          _buildAmountRow('Basic Salary', salary.basicSalary),
          _buildAmountRow('HRA', salary.hra),
          _buildAmountRow('DA', salary.da),
          _buildAmountRow('TA', salary.ta),
          _buildAmountRow('Medical Allowance', salary.medicalAllowance),
          if (salary.specialAllowance > 0)
            _buildAmountRow('Special Allowance', salary.specialAllowance),
          if (salary.otherAllowances > 0)
            _buildAmountRow('Other Allowances', salary.otherAllowances),
          pw.Divider(color: PdfColors.green300),
          _buildAmountRow('Total Earnings', salary.grossSalary, bold: true),
        ],
      ),
    );
  }

  pw.Widget _buildDeductions(Salary salary) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(12),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.red700),
        borderRadius: pw.BorderRadius.circular(8),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            'DEDUCTIONS',
            style: pw.TextStyle(
              fontSize: 14,
              fontWeight: pw.FontWeight.bold,
              color: PdfColors.red800,
            ),
          ),
          pw.Divider(color: PdfColors.red300),
          ...salary.deductions.map(
            (d) => _buildAmountRow(d.name, d.amount),
          ),
          pw.Divider(color: PdfColors.red300),
          _buildAmountRow('Total Deductions', salary.totalDeductions, bold: true),
        ],
      ),
    );
  }

  pw.Widget _buildAmountRow(String label, double amount, {bool bold = false}) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 4),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(
            label,
            style: pw.TextStyle(
              fontSize: bold ? 11 : 10,
              fontWeight: bold ? pw.FontWeight.bold : pw.FontWeight.normal,
            ),
          ),
          pw.Text(
            Formatters.formatCurrency(amount),
            style: pw.TextStyle(
              fontSize: bold ? 11 : 10,
              fontWeight: bold ? pw.FontWeight.bold : pw.FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  pw.Widget _buildSummary(Salary salary) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(16),
      decoration: pw.BoxDecoration(
        color: PdfColors.blue50,
        border: pw.Border.all(color: PdfColors.blue800, width: 2),
        borderRadius: pw.BorderRadius.circular(8),
      ),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                'NET SALARY (TAKE HOME)',
                style: pw.TextStyle(
                  fontSize: 14,
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColors.blue900,
                ),
              ),
              pw.Text(
                'Gross - Deductions',
                style: const pw.TextStyle(
                  fontSize: 10,
                  color: PdfColors.grey600,
                ),
              ),
            ],
          ),
          pw.Text(
            Formatters.formatCurrency(salary.netSalary),
            style: pw.TextStyle(
              fontSize: 24,
              fontWeight: pw.FontWeight.bold,
              color: PdfColors.blue900,
            ),
          ),
        ],
      ),
    );
  }

  pw.Widget _buildFooter() {
    return pw.Column(
      children: [
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  '___________________________',
                  style: const pw.TextStyle(color: PdfColors.grey400),
                ),
                pw.SizedBox(height: 4),
                pw.Text(
                  'Employee Signature',
                  style: const pw.TextStyle(
                    fontSize: 10,
                    color: PdfColors.grey700,
                  ),
                ),
              ],
            ),
            pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.end,
              children: [
                pw.Text(
                  '___________________________',
                  style: const pw.TextStyle(color: PdfColors.grey400),
                ),
                pw.SizedBox(height: 4),
                pw.Text(
                  'Authorized Signature',
                  style: const pw.TextStyle(
                    fontSize: 10,
                    color: PdfColors.grey700,
                  ),
                ),
              ],
            ),
          ],
        ),
        pw.SizedBox(height: 20),
        pw.Text(
          'This is a computer-generated document and does not require a signature.',
          style: const pw.TextStyle(
            fontSize: 8,
            color: PdfColors.grey500,
          ),
        ),
      ],
    );
  }

  /// Save PDF to file and return file path
  /// Throws an exception if the file cannot be written
  Future<String> savePdfToFile(Uint8List pdfBytes, String fileName) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/$fileName');
      await file.writeAsBytes(pdfBytes);
      return file.path;
    } on FileSystemException catch (e) {
      throw Exception('Failed to save PDF: ${e.message}');
    }
  }
}
