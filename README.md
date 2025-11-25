# Flutter Salary Management App

A comprehensive Flutter salary management application with modern UI for tracking and managing employee salaries.

## Features

### 📊 Dashboard
- Summary cards showing total employees, salary disbursed, average salary, and pending payments
- Monthly salary trend chart using fl_chart
- Quick action buttons for common tasks

### 💰 Salary Calculator
- Real-time salary calculation
- Configurable allowances (HRA, DA, TA, Medical)
- Configurable deductions (Tax, PF, Insurance, Loans)
- Gross and net salary breakdown

### 👥 Employee Management
- Complete employee list with search functionality
- Add, edit, and delete employees
- Detailed employee profiles
- Department and designation management
- Bank account details storage

### 📝 Payment History
- Track all salary payments
- Filter by status (Paid, Pending, Processing)
- Filter by month and employee
- Payment status management

### 🧾 Payslip Generation
- Professional payslip view
- PDF generation and export
- Share payslip functionality

### ⚙️ Settings
- Company information configuration
- Currency selection
- Tax slab configuration
- Dark/Light theme toggle

## Project Structure

```
lib/
├── main.dart
├── app.dart
├── config/
│   ├── theme.dart
│   └── constants.dart
├── models/
│   ├── employee.dart
│   ├── salary.dart
│   ├── deduction.dart
│   └── payment_history.dart
├── providers/
│   └── salary_provider.dart
├── screens/
│   ├── home_screen.dart
│   ├── dashboard_screen.dart
│   ├── salary_calculator_screen.dart
│   ├── payment_history_screen.dart
│   ├── employee_list_screen.dart
│   ├── employee_detail_screen.dart
│   ├── add_employee_screen.dart
│   ├── payslip_screen.dart
│   └── settings_screen.dart
├── widgets/
│   ├── salary_card.dart
│   ├── stat_card.dart
│   ├── employee_tile.dart
│   ├── deduction_item.dart
│   ├── chart_widget.dart
│   └── custom_button.dart
├── services/
│   ├── database_service.dart
│   └── pdf_service.dart
└── utils/
    ├── formatters.dart
    └── validators.dart
```

## Screenshots

*Screenshots coming soon*

## Getting Started

### Prerequisites
- Flutter SDK (>=3.0.0)
- Dart SDK
- Android Studio / VS Code with Flutter extensions

### Installation

1. Clone the repository:
```bash
git clone https://github.com/Navaskt/flutter_salary_management.git
```

2. Navigate to the project directory:
```bash
cd flutter_salary_management
```

3. Install dependencies:
```bash
flutter pub get
```

4. Run the app:
```bash
flutter run
```

## Dependencies

- **provider**: State management
- **fl_chart**: Beautiful charts
- **pdf**: PDF generation
- **path_provider**: File system access
- **share_plus**: Sharing functionality
- **intl**: Internationalization and formatting
- **sqflite**: Local database
- **google_fonts**: Custom fonts
- **flutter_slidable**: Swipe actions

## Technical Features

- **Material Design 3**: Modern UI with latest Material Design guidelines
- **Dark/Light Theme**: Full theme support with dynamic switching
- **State Management**: Provider pattern for clean state management
- **PDF Export**: Generate and share professional payslips
- **Form Validation**: Comprehensive input validation
- **Responsive Design**: Works on various screen sizes

## Sample Data

The app includes sample data for demonstration:
- 8 sample employees across different departments
- 6 months of payment history
- Various salary structures and payment statuses

## License

This project is licensed under the MIT License.

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.