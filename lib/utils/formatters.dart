import 'package:intl/intl.dart';

class Formatters {
  static final _currencyFormat = NumberFormat.currency(
    symbol: '\$',
    decimalDigits: 2,
  );

  static final _compactCurrencyFormat = NumberFormat.compactCurrency(
    symbol: '\$',
    decimalDigits: 1,
  );

  static final _numberFormat = NumberFormat('#,##0.00');

  static final _percentFormat = NumberFormat.percentPattern();

  static final _dateFormat = DateFormat('MMM dd, yyyy');

  static final _shortDateFormat = DateFormat('dd/MM/yyyy');

  static final _monthYearFormat = DateFormat('MMMM yyyy');

  static final _monthFormat = DateFormat('MMM yyyy');

  static final _timeFormat = DateFormat('hh:mm a');

  /// Format amount as currency (e.g., \$1,234.56)
  static String formatCurrency(double amount) {
    return _currencyFormat.format(amount);
  }

  /// Format large amounts in compact form (e.g., \$1.2K, \$1.5M)
  static String formatCompactCurrency(double amount) {
    return _compactCurrencyFormat.format(amount);
  }

  /// Format number with commas (e.g., 1,234.56)
  static String formatNumber(double number) {
    return _numberFormat.format(number);
  }

  /// Format as percentage (e.g., 12%)
  static String formatPercent(double value) {
    return _percentFormat.format(value / 100);
  }

  /// Format date as "MMM dd, yyyy" (e.g., Jan 15, 2024)
  static String formatDate(DateTime date) {
    return _dateFormat.format(date);
  }

  /// Format date as "dd/MM/yyyy" (e.g., 15/01/2024)
  static String formatShortDate(DateTime date) {
    return _shortDateFormat.format(date);
  }

  /// Format date as "MMMM yyyy" (e.g., January 2024)
  static String formatMonthYear(DateTime date) {
    return _monthYearFormat.format(date);
  }

  /// Format date as "MMM yyyy" (e.g., Jan 2024)
  static String formatMonth(DateTime date) {
    return _monthFormat.format(date);
  }

  /// Format time as "hh:mm a" (e.g., 02:30 PM)
  static String formatTime(DateTime time) {
    return _timeFormat.format(time);
  }

  /// Format employee ID with prefix (e.g., EMP001)
  static String formatEmployeeId(int id) {
    return 'EMP${id.toString().padLeft(3, '0')}';
  }

  /// Format bank account number with masked digits
  static String maskBankAccount(String accountNumber) {
    if (accountNumber.length <= 4) return accountNumber;
    final visible = accountNumber.substring(accountNumber.length - 4);
    final masked = '*' * (accountNumber.length - 4);
    return '$masked$visible';
  }

  /// Format phone number
  static String formatPhone(String phone) {
    final cleaned = phone.replaceAll(RegExp(r'\D'), '');
    if (cleaned.length == 10) {
      return '(${cleaned.substring(0, 3)}) ${cleaned.substring(3, 6)}-${cleaned.substring(6)}';
    }
    return phone;
  }

  /// Get initials from name
  static String getInitials(String name) {
    final parts = name.trim().split(' ');
    if (parts.isEmpty) return '';
    if (parts.length == 1) return parts[0][0].toUpperCase();
    return '${parts[0][0]}${parts[parts.length - 1][0]}'.toUpperCase();
  }

  /// Format duration in years and months
  static String formatDuration(Duration duration) {
    final years = duration.inDays ~/ 365;
    final months = (duration.inDays % 365) ~/ 30;

    if (years == 0 && months == 0) return 'Less than a month';
    if (years == 0) return '$months month${months > 1 ? 's' : ''}';
    if (months == 0) return '$years year${years > 1 ? 's' : ''}';
    return '$years year${years > 1 ? 's' : ''}, $months month${months > 1 ? 's' : ''}';
  }
}
