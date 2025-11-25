class Validators {
  /// Validate email address
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    if (!emailRegex.hasMatch(value)) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  /// Validate phone number
  static String? validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Phone number is required';
    }
    final cleaned = value.replaceAll(RegExp(r'\D'), '');
    if (cleaned.length < 10) {
      return 'Phone number must be at least 10 digits';
    }
    return null;
  }

  /// Validate required field
  static String? validateRequired(String? value, [String? fieldName]) {
    if (value == null || value.trim().isEmpty) {
      return '${fieldName ?? 'This field'} is required';
    }
    return null;
  }

  /// Validate name
  static String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Name is required';
    }
    if (value.length < 2) {
      return 'Name must be at least 2 characters';
    }
    if (value.length > 100) {
      return 'Name must be less than 100 characters';
    }
    final nameRegex = RegExp(r"^[a-zA-Z\s'-]+$");
    if (!nameRegex.hasMatch(value)) {
      return 'Name can only contain letters, spaces, hyphens, and apostrophes';
    }
    return null;
  }

  /// Validate employee ID
  static String? validateEmployeeId(String? value) {
    if (value == null || value.isEmpty) {
      return 'Employee ID is required';
    }
    if (value.length < 3) {
      return 'Employee ID must be at least 3 characters';
    }
    return null;
  }

  /// Validate bank account number
  static String? validateBankAccount(String? value) {
    if (value == null || value.isEmpty) {
      return 'Bank account number is required';
    }
    final cleaned = value.replaceAll(RegExp(r'\D'), '');
    if (cleaned.length < 8 || cleaned.length > 18) {
      return 'Bank account number must be between 8 and 18 digits';
    }
    return null;
  }

  /// Validate IFSC code
  static String? validateIfscCode(String? value) {
    if (value == null || value.isEmpty) {
      return 'IFSC code is required';
    }
    final ifscRegex = RegExp(r'^[A-Z]{4}0[A-Z0-9]{6}$');
    if (!ifscRegex.hasMatch(value.toUpperCase())) {
      return 'Please enter a valid IFSC code';
    }
    return null;
  }

  /// Validate salary amount
  static String? validateSalary(String? value) {
    if (value == null || value.isEmpty) {
      return 'Salary is required';
    }
    final salary = double.tryParse(value.replaceAll(',', ''));
    if (salary == null) {
      return 'Please enter a valid amount';
    }
    if (salary < 0) {
      return 'Salary cannot be negative';
    }
    if (salary > 10000000) {
      return 'Please enter a valid salary amount';
    }
    return null;
  }

  /// Validate positive number
  static String? validatePositiveNumber(String? value, [String? fieldName]) {
    if (value == null || value.isEmpty) {
      return '${fieldName ?? 'This field'} is required';
    }
    final number = double.tryParse(value.replaceAll(',', ''));
    if (number == null) {
      return 'Please enter a valid number';
    }
    if (number < 0) {
      return '${fieldName ?? 'Value'} cannot be negative';
    }
    return null;
  }

  /// Validate percentage (0-100)
  static String? validatePercentage(String? value, [String? fieldName]) {
    if (value == null || value.isEmpty) {
      return null; // Optional field
    }
    final percent = double.tryParse(value);
    if (percent == null) {
      return 'Please enter a valid percentage';
    }
    if (percent < 0 || percent > 100) {
      return '${fieldName ?? 'Percentage'} must be between 0 and 100';
    }
    return null;
  }

  /// Validate date is not in the future
  static String? validatePastDate(DateTime? value, [String? fieldName]) {
    if (value == null) {
      return '${fieldName ?? 'Date'} is required';
    }
    if (value.isAfter(DateTime.now())) {
      return '${fieldName ?? 'Date'} cannot be in the future';
    }
    return null;
  }

  /// Check if string is a valid number
  static bool isValidNumber(String value) {
    return double.tryParse(value.replaceAll(',', '')) != null;
  }

  /// Parse string to double safely
  static double parseDouble(String value, [double defaultValue = 0]) {
    return double.tryParse(value.replaceAll(',', '')) ?? defaultValue;
  }
}
