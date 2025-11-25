import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/salary_provider.dart';
import '../config/theme.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Consumer<SalaryProvider>(
        builder: (context, provider, child) {
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Company Information
              _buildSectionTitle(context, 'Company Information'),
              Card(
                child: Column(
                  children: [
                    ListTile(
                      leading: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryColor.withAlpha(25),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          Icons.business,
                          color: AppTheme.primaryColor,
                        ),
                      ),
                      title: const Text('Company Name'),
                      subtitle: Text(provider.companyName),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () => _showCompanyNameDialog(context, provider),
                    ),
                    const Divider(height: 1),
                    ListTile(
                      leading: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryColor.withAlpha(25),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          Icons.location_on,
                          color: AppTheme.primaryColor,
                        ),
                      ),
                      title: const Text('Company Address'),
                      subtitle: const Text('123 Business Park, Tech City'),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Address editing coming soon!')),
                        );
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Preferences
              _buildSectionTitle(context, 'Preferences'),
              Card(
                child: Column(
                  children: [
                    ListTile(
                      leading: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppTheme.secondaryColor.withAlpha(25),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          Icons.attach_money,
                          color: AppTheme.secondaryColor,
                        ),
                      ),
                      title: const Text('Currency'),
                      subtitle: Text('${provider.currency} (${provider.currencySymbol})'),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () => _showCurrencyDialog(context, provider),
                    ),
                    const Divider(height: 1),
                    SwitchListTile(
                      secondary: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppTheme.secondaryColor.withAlpha(25),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          provider.isDarkMode ? Icons.dark_mode : Icons.light_mode,
                          color: AppTheme.secondaryColor,
                        ),
                      ),
                      title: const Text('Dark Mode'),
                      subtitle: Text(provider.isDarkMode ? 'Enabled' : 'Disabled'),
                      value: provider.isDarkMode,
                      onChanged: (_) => provider.toggleTheme(),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Tax Configuration
              _buildSectionTitle(context, 'Tax Configuration'),
              Card(
                child: Column(
                  children: [
                    ListTile(
                      leading: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.orange.withAlpha(25),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.receipt_long,
                          color: Colors.orange,
                        ),
                      ),
                      title: const Text('Tax Slabs'),
                      subtitle: const Text('Configure income tax slabs'),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () => _showTaxSlabsDialog(context),
                    ),
                    const Divider(height: 1),
                    ListTile(
                      leading: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.orange.withAlpha(25),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.savings,
                          color: Colors.orange,
                        ),
                      ),
                      title: const Text('Default Deductions'),
                      subtitle: const Text('PF, Insurance, Professional Tax'),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Deduction settings coming soon!')),
                        );
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Data Management
              _buildSectionTitle(context, 'Data Management'),
              Card(
                child: Column(
                  children: [
                    ListTile(
                      leading: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.purple.withAlpha(25),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.backup,
                          color: Colors.purple,
                        ),
                      ),
                      title: const Text('Backup Data'),
                      subtitle: const Text('Export all data to file'),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Backup feature coming soon!')),
                        );
                      },
                    ),
                    const Divider(height: 1),
                    ListTile(
                      leading: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.purple.withAlpha(25),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.restore,
                          color: Colors.purple,
                        ),
                      ),
                      title: const Text('Restore Data'),
                      subtitle: const Text('Import data from backup file'),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Restore feature coming soon!')),
                        );
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // About
              _buildSectionTitle(context, 'About'),
              Card(
                child: Column(
                  children: [
                    ListTile(
                      leading: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.blue.withAlpha(25),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.info,
                          color: Colors.blue,
                        ),
                      ),
                      title: const Text('App Version'),
                      subtitle: const Text('1.0.0'),
                    ),
                    const Divider(height: 1),
                    ListTile(
                      leading: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.blue.withAlpha(25),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.description,
                          color: Colors.blue,
                        ),
                      ),
                      title: const Text('Terms of Service'),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () {},
                    ),
                    const Divider(height: 1),
                    ListTile(
                      leading: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.blue.withAlpha(25),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.privacy_tip,
                          color: Colors.blue,
                        ),
                      ),
                      title: const Text('Privacy Policy'),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () {},
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.grey[700],
            ),
      ),
    );
  }

  void _showCompanyNameDialog(BuildContext context, SalaryProvider provider) {
    final controller = TextEditingController(text: provider.companyName);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Company Name'),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(
              labelText: 'Enter company name',
            ),
            autofocus: true,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                provider.updateCompanyName(controller.text.trim());
                Navigator.pop(context);
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _showCurrencyDialog(BuildContext context, SalaryProvider provider) {
    final currencies = [
      {'code': 'USD', 'symbol': '\$', 'name': 'US Dollar'},
      {'code': 'EUR', 'symbol': '€', 'name': 'Euro'},
      {'code': 'GBP', 'symbol': '£', 'name': 'British Pound'},
      {'code': 'INR', 'symbol': '₹', 'name': 'Indian Rupee'},
      {'code': 'JPY', 'symbol': '¥', 'name': 'Japanese Yen'},
      {'code': 'AUD', 'symbol': 'A\$', 'name': 'Australian Dollar'},
      {'code': 'CAD', 'symbol': 'C\$', 'name': 'Canadian Dollar'},
    ];

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Select Currency'),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: currencies.length,
              itemBuilder: (context, index) {
                final currency = currencies[index];
                final isSelected = provider.currency == currency['code'];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: isSelected
                        ? AppTheme.primaryColor
                        : Colors.grey[200],
                    child: Text(
                      currency['symbol']!,
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
                  title: Text(currency['name']!),
                  subtitle: Text(currency['code']!),
                  trailing: isSelected
                      ? const Icon(Icons.check, color: AppTheme.primaryColor)
                      : null,
                  onTap: () {
                    provider.updateCurrency(
                      currency['code']!,
                      currency['symbol']!,
                    );
                    Navigator.pop(context);
                  },
                );
              },
            ),
          ),
        );
      },
    );
  }

  void _showTaxSlabsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Tax Slabs'),
          content: SingleChildScrollView(
            child: DataTable(
              columns: const [
                DataColumn(label: Text('Income Range')),
                DataColumn(label: Text('Rate')),
              ],
              rows: const [
                DataRow(cells: [
                  DataCell(Text('\$0 - \$10,275')),
                  DataCell(Text('10%')),
                ]),
                DataRow(cells: [
                  DataCell(Text('\$10,276 - \$41,775')),
                  DataCell(Text('12%')),
                ]),
                DataRow(cells: [
                  DataCell(Text('\$41,776 - \$89,075')),
                  DataCell(Text('22%')),
                ]),
                DataRow(cells: [
                  DataCell(Text('\$89,076 - \$170,050')),
                  DataCell(Text('24%')),
                ]),
                DataRow(cells: [
                  DataCell(Text('\$170,051 - \$215,950')),
                  DataCell(Text('32%')),
                ]),
                DataRow(cells: [
                  DataCell(Text('\$215,951 - \$539,900')),
                  DataCell(Text('35%')),
                ]),
                DataRow(cells: [
                  DataCell(Text('\$539,901+')),
                  DataCell(Text('37%')),
                ]),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }
}
