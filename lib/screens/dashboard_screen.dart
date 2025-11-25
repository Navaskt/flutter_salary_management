import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/salary_provider.dart';
import '../widgets/stat_card.dart';
import '../widgets/chart_widget.dart';
import '../widgets/custom_button.dart';
import '../config/theme.dart';
import 'salary_calculator_screen.dart';
import 'add_employee_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Salary Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('No new notifications')),
              );
            },
          ),
        ],
      ),
      body: Consumer<SalaryProvider>(
        builder: (context, provider, child) {
          return RefreshIndicator(
            onRefresh: () async {
              await provider.loadEmployees();
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  // Stats Cards
                  _buildStatsGrid(context, provider),
                  const SizedBox(height: 8),
                  // Monthly Trend Chart
                  ChartWidget(
                    data: provider.getMonthlySalaryData(),
                    title: 'Monthly Salary Disbursement',
                  ),
                  // Quick Actions
                  _buildQuickActions(context),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatsGrid(BuildContext context, SalaryProvider provider) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GridView.count(
        crossAxisCount: 2,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 1.3,
        children: [
          StatCard.number(
            title: 'Total Employees',
            count: provider.totalEmployees,
            icon: Icons.people,
            color: AppTheme.primaryColor,
            subtitle: 'Active employees',
          ),
          StatCard.currency(
            title: 'Total Disbursed',
            amount: provider.totalSalaryDisbursed,
            icon: Icons.account_balance_wallet,
            color: AppTheme.successColor,
            subtitle: 'All time',
          ),
          StatCard.currency(
            title: 'Average Salary',
            amount: provider.averageSalary,
            icon: Icons.trending_up,
            color: AppTheme.secondaryColor,
            subtitle: 'Per employee',
          ),
          StatCard.number(
            title: 'Pending Payments',
            count: provider.pendingPayments,
            icon: Icons.pending_actions,
            color: AppTheme.warningColor,
            subtitle: 'This month',
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Quick Actions',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: QuickActionButton(
                  icon: Icons.calculate,
                  label: 'Calculate\nSalary',
                  color: AppTheme.primaryColor,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const SalaryCalculatorScreen(),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: QuickActionButton(
                  icon: Icons.person_add,
                  label: 'Add\nEmployee',
                  color: AppTheme.secondaryColor,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const AddEmployeeScreen(),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: QuickActionButton(
                  icon: Icons.receipt_long,
                  label: 'Generate\nPayslip',
                  color: AppTheme.successColor,
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Select an employee to generate payslip'),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: QuickActionButton(
                  icon: Icons.download,
                  label: 'Export\nReport',
                  color: Colors.purple,
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Report export coming soon!')),
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
