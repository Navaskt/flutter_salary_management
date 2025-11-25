class AppConstants {
  // App Information
  static const String appName = 'Salary Management';
  static const String appVersion = '1.0.0';

  // Default Company Info
  static const String defaultCompanyName = 'ABC Corporation';
  static const String defaultCompanyAddress = '123 Business Park, Tech City';
  static const String defaultCompanyEmail = 'hr@abccorp.com';
  static const String defaultCompanyPhone = '+1 234 567 8900';

  // Currency
  static const String defaultCurrency = 'USD';
  static const String defaultCurrencySymbol = '\$';

  // Tax Slabs (US Example)
  static const List<TaxSlab> taxSlabs = [
    TaxSlab(minIncome: 0, maxIncome: 10275, rate: 10),
    TaxSlab(minIncome: 10276, maxIncome: 41775, rate: 12),
    TaxSlab(minIncome: 41776, maxIncome: 89075, rate: 22),
    TaxSlab(minIncome: 89076, maxIncome: 170050, rate: 24),
    TaxSlab(minIncome: 170051, maxIncome: 215950, rate: 32),
    TaxSlab(minIncome: 215951, maxIncome: 539900, rate: 35),
    TaxSlab(minIncome: 539901, maxIncome: double.infinity, rate: 37),
  ];

  // Default Allowance Rates (as percentage of basic)
  static const double defaultHraRate = 40.0;
  static const double defaultDaRate = 12.0;
  static const double defaultTaRate = 10.0;
  static const double defaultMedicalRate = 5.0;

  // Default Deduction Rates
  static const double defaultPfRate = 12.0;
  static const double defaultProfessionalTax = 200.0;
  static const double defaultInsuranceRate = 2.0;

  // Payment Status
  static const String statusPaid = 'Paid';
  static const String statusPending = 'Pending';
  static const String statusProcessing = 'Processing';

  // Departments
  static const List<String> departments = [
    'Engineering',
    'Design',
    'Marketing',
    'Sales',
    'Human Resources',
    'Finance',
    'Operations',
    'Customer Support',
    'Research & Development',
    'Legal',
  ];

  // Designations
  static const List<String> designations = [
    'Junior Developer',
    'Senior Developer',
    'Lead Developer',
    'Software Architect',
    'Designer',
    'Senior Designer',
    'UX Lead',
    'Marketing Executive',
    'Marketing Manager',
    'Sales Representative',
    'Sales Manager',
    'HR Executive',
    'HR Manager',
    'Finance Executive',
    'Finance Manager',
    'Operations Executive',
    'Operations Manager',
    'Team Lead',
    'Project Manager',
    'Director',
    'Vice President',
    'CEO',
    'CTO',
    'CFO',
  ];

  // Months
  static const List<String> months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];
}

class TaxSlab {
  final double minIncome;
  final double maxIncome;
  final double rate;

  const TaxSlab({
    required this.minIncome,
    required this.maxIncome,
    required this.rate,
  });

  double calculateTax(double income) {
    if (income < minIncome) return 0;
    final taxableIncome =
        income > maxIncome ? maxIncome - minIncome : income - minIncome;
    return taxableIncome * rate / 100;
  }
}
