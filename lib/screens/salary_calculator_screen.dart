import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/salary_provider.dart';
import '../models/salary.dart';
import '../models/deduction.dart';
import '../utils/formatters.dart';
import '../utils/validators.dart';
import '../widgets/deduction_item.dart';
import '../widgets/custom_button.dart';
import '../config/theme.dart';

class SalaryCalculatorScreen extends StatefulWidget {
  const SalaryCalculatorScreen({super.key});

  @override
  State<SalaryCalculatorScreen> createState() => _SalaryCalculatorScreenState();
}

class _SalaryCalculatorScreenState extends State<SalaryCalculatorScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final _basicSalaryController = TextEditingController(text: '5000');
  final _hraRateController = TextEditingController(text: '40');
  final _daRateController = TextEditingController(text: '12');
  final _taRateController = TextEditingController(text: '10');
  final _medicalRateController = TextEditingController(text: '5');
  final _specialAllowanceController = TextEditingController(text: '0');

  // Deduction controllers
  final _pfRateController = TextEditingController(text: '12');
  final _taxRateController = TextEditingController(text: '10');
  final _insuranceController = TextEditingController(text: '100');
  final _loanController = TextEditingController(text: '0');

  Salary? _calculatedSalary;

  @override
  void initState() {
    super.initState();
    _calculateSalary();
  }

  @override
  void dispose() {
    _basicSalaryController.dispose();
    _hraRateController.dispose();
    _daRateController.dispose();
    _taRateController.dispose();
    _medicalRateController.dispose();
    _specialAllowanceController.dispose();
    _pfRateController.dispose();
    _taxRateController.dispose();
    _insuranceController.dispose();
    _loanController.dispose();
    super.dispose();
  }

  void _calculateSalary() {
    final basicSalary = Validators.parseDouble(_basicSalaryController.text);
    final hraRate = Validators.parseDouble(_hraRateController.text);
    final daRate = Validators.parseDouble(_daRateController.text);
    final taRate = Validators.parseDouble(_taRateController.text);
    final medicalRate = Validators.parseDouble(_medicalRateController.text);
    final specialAllowance = Validators.parseDouble(_specialAllowanceController.text);

    final pfRate = Validators.parseDouble(_pfRateController.text);
    final taxRate = Validators.parseDouble(_taxRateController.text);
    final insurance = Validators.parseDouble(_insuranceController.text);
    final loan = Validators.parseDouble(_loanController.text);

    final hra = basicSalary * hraRate / 100;
    final da = basicSalary * daRate / 100;
    final ta = basicSalary * taRate / 100;
    final medical = basicSalary * medicalRate / 100;

    final gross = basicSalary + hra + da + ta + medical + specialAllowance;

    final deductions = <Deduction>[
      Deduction(
        id: 'pf',
        name: 'Provident Fund',
        amount: basicSalary * pfRate / 100,
        type: DeductionType.pf,
      ),
      Deduction(
        id: 'tax',
        name: 'Income Tax',
        amount: gross * taxRate / 100,
        type: DeductionType.tax,
      ),
      Deduction(
        id: 'insurance',
        name: 'Insurance',
        amount: insurance,
        type: DeductionType.insurance,
      ),
      if (loan > 0)
        Deduction(
          id: 'loan',
          name: 'Loan EMI',
          amount: loan,
          type: DeductionType.loan,
        ),
    ];

    setState(() {
      _calculatedSalary = Salary(
        id: 'calc_${DateTime.now().millisecondsSinceEpoch}',
        employeeId: '',
        basicSalary: basicSalary,
        hra: hra,
        da: da,
        ta: ta,
        medicalAllowance: medical,
        specialAllowance: specialAllowance,
        deductions: deductions,
        month: DateTime.now(),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Salary Calculator'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              _basicSalaryController.text = '5000';
              _hraRateController.text = '40';
              _daRateController.text = '12';
              _taRateController.text = '10';
              _medicalRateController.text = '5';
              _specialAllowanceController.text = '0';
              _pfRateController.text = '12';
              _taxRateController.text = '10';
              _insuranceController.text = '100';
              _loanController.text = '0';
              _calculateSalary();
            },
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Earnings Section
              _buildSectionHeader('Earnings', Icons.add_circle, Colors.green),
              const SizedBox(height: 12),
              _buildEarningsCard(),
              const SizedBox(height: 24),

              // Deductions Section
              _buildSectionHeader('Deductions', Icons.remove_circle, Colors.red),
              const SizedBox(height: 12),
              _buildDeductionsCard(),
              const SizedBox(height: 24),

              // Summary Section
              if (_calculatedSalary != null) ...[
                _buildSectionHeader('Salary Summary', Icons.summarize, AppTheme.primaryColor),
                const SizedBox(height: 12),
                _buildSummaryCard(),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon, Color color) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withAlpha(25),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        const SizedBox(width: 12),
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
      ],
    );
  }

  Widget _buildEarningsCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildInputField(
              label: 'Basic Salary',
              controller: _basicSalaryController,
              prefixText: '\$',
              onChanged: (_) => _calculateSalary(),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildInputField(
                    label: 'HRA (%)',
                    controller: _hraRateController,
                    suffixText: '%',
                    onChanged: (_) => _calculateSalary(),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildInputField(
                    label: 'DA (%)',
                    controller: _daRateController,
                    suffixText: '%',
                    onChanged: (_) => _calculateSalary(),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildInputField(
                    label: 'TA (%)',
                    controller: _taRateController,
                    suffixText: '%',
                    onChanged: (_) => _calculateSalary(),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildInputField(
                    label: 'Medical (%)',
                    controller: _medicalRateController,
                    suffixText: '%',
                    onChanged: (_) => _calculateSalary(),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildInputField(
              label: 'Special Allowance',
              controller: _specialAllowanceController,
              prefixText: '\$',
              onChanged: (_) => _calculateSalary(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDeductionsCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: _buildInputField(
                    label: 'PF Rate (%)',
                    controller: _pfRateController,
                    suffixText: '%',
                    onChanged: (_) => _calculateSalary(),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildInputField(
                    label: 'Tax Rate (%)',
                    controller: _taxRateController,
                    suffixText: '%',
                    onChanged: (_) => _calculateSalary(),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildInputField(
                    label: 'Insurance',
                    controller: _insuranceController,
                    prefixText: '\$',
                    onChanged: (_) => _calculateSalary(),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildInputField(
                    label: 'Loan EMI',
                    controller: _loanController,
                    prefixText: '\$',
                    onChanged: (_) => _calculateSalary(),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField({
    required String label,
    required TextEditingController controller,
    String? prefixText,
    String? suffixText,
    void Function(String)? onChanged,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: label,
        prefixText: prefixText,
        suffixText: suffixText,
      ),
      onChanged: onChanged,
    );
  }

  Widget _buildSummaryCard() {
    final salary = _calculatedSalary!;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Earnings breakdown
            _buildSummaryRow('Basic Salary', salary.basicSalary, isPositive: true),
            _buildSummaryRow('HRA', salary.hra, isPositive: true),
            _buildSummaryRow('DA', salary.da, isPositive: true),
            _buildSummaryRow('TA', salary.ta, isPositive: true),
            _buildSummaryRow('Medical Allowance', salary.medicalAllowance, isPositive: true),
            if (salary.specialAllowance > 0)
              _buildSummaryRow('Special Allowance', salary.specialAllowance, isPositive: true),
            const Divider(height: 24),
            _buildSummaryRow('Gross Salary', salary.grossSalary, isTotal: true, isPositive: true),
            const SizedBox(height: 16),

            // Deductions
            ...salary.deductions.map((d) => DeductionItem(deduction: d)),
            const Divider(height: 24),
            _buildSummaryRow('Total Deductions', salary.totalDeductions, isTotal: true, isPositive: false),
            const Divider(height: 24),

            // Net Salary
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withAlpha(25),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppTheme.primaryColor),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'NET SALARY',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    Formatters.formatCurrency(salary.netSalary),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
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

  Widget _buildSummaryRow(
    String label,
    double amount, {
    bool isTotal = false,
    bool isPositive = true,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              fontSize: isTotal ? 15 : 14,
            ),
          ),
          Text(
            '${isPositive ? '+' : '-'} ${Formatters.formatCurrency(amount)}',
            style: TextStyle(
              fontWeight: isTotal ? FontWeight.bold : FontWeight.w500,
              fontSize: isTotal ? 15 : 14,
              color: isPositive ? Colors.green : Colors.red,
            ),
          ),
        ],
      ),
    );
  }
}
