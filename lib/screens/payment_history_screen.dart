import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/salary_provider.dart';
import '../models/payment_history.dart';
import '../utils/formatters.dart';
import '../config/theme.dart';

class PaymentHistoryScreen extends StatefulWidget {
  const PaymentHistoryScreen({super.key});

  @override
  State<PaymentHistoryScreen> createState() => _PaymentHistoryScreenState();
}

class _PaymentHistoryScreenState extends State<PaymentHistoryScreen> {
  String _selectedFilter = 'All';
  String _searchQuery = '';

  final List<String> _filters = ['All', 'Paid', 'Pending', 'Processing'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment History'),
        actions: [
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Export feature coming soon!')),
              );
            },
          ),
        ],
      ),
      body: Consumer<SalaryProvider>(
        builder: (context, provider, child) {
          final payments = _getFilteredPayments(provider.paymentHistory);

          return Column(
            children: [
              // Search and Filter
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    // Search
                    TextField(
                      decoration: InputDecoration(
                        hintText: 'Search by employee name...',
                        prefixIcon: const Icon(Icons.search),
                        suffixIcon: _searchQuery.isNotEmpty
                            ? IconButton(
                                icon: const Icon(Icons.clear),
                                onPressed: () {
                                  setState(() {
                                    _searchQuery = '';
                                  });
                                },
                              )
                            : null,
                      ),
                      onChanged: (value) {
                        setState(() {
                          _searchQuery = value;
                        });
                      },
                    ),
                    const SizedBox(height: 12),
                    // Filter chips
                    SizedBox(
                      height: 40,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: _filters.length,
                        itemBuilder: (context, index) {
                          final filter = _filters[index];
                          final isSelected = _selectedFilter == filter;
                          return Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: FilterChip(
                              label: Text(filter),
                              selected: isSelected,
                              onSelected: (selected) {
                                setState(() {
                                  _selectedFilter = filter;
                                });
                              },
                              selectedColor: AppTheme.primaryColor.withAlpha(51),
                              checkmarkColor: AppTheme.primaryColor,
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),

              // Summary
              _buildSummary(provider),

              // Payment List
              Expanded(
                child: payments.isEmpty
                    ? _buildEmptyState()
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: payments.length,
                        itemBuilder: (context, index) {
                          return _buildPaymentCard(context, payments[index], provider);
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }

  List<PaymentHistory> _getFilteredPayments(List<PaymentHistory> payments) {
    var filtered = payments;

    // Filter by status
    if (_selectedFilter != 'All') {
      final status = PaymentStatus.values.firstWhere(
        (s) => s.name.toLowerCase() == _selectedFilter.toLowerCase(),
        orElse: () => PaymentStatus.paid,
      );
      filtered = filtered.where((p) => p.status == status).toList();
    }

    // Filter by search
    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((p) {
        return p.employeeName.toLowerCase().contains(_searchQuery.toLowerCase());
      }).toList();
    }

    // Sort by date (newest first)
    filtered.sort((a, b) => b.paymentDate.compareTo(a.paymentDate));

    return filtered;
  }

  Widget _buildSummary(SalaryProvider provider) {
    final paidAmount = provider.paymentHistory
        .where((p) => p.status == PaymentStatus.paid)
        .fold(0.0, (sum, p) => sum + p.amount);
    final pendingAmount = provider.pendingAmount;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppTheme.primaryColor, AppTheme.primaryDark],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Total Paid',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  Formatters.formatCompactCurrency(paidAmount),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 1,
            height: 40,
            color: Colors.white24,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Pending',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    Formatters.formatCompactCurrency(pendingAmount),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.receipt_long, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'No payments found',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Payments will appear here',
            style: TextStyle(
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentCard(
    BuildContext context,
    PaymentHistory payment,
    SalaryProvider provider,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          _showPaymentDetails(context, payment);
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: _getStatusColor(payment.status).withAlpha(25),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Text(
                        Formatters.getInitials(payment.employeeName),
                        style: TextStyle(
                          color: _getStatusColor(payment.status),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          payment.employeeName,
                          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          Formatters.formatMonthYear(payment.salaryMonth),
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        Formatters.formatCurrency(payment.amount),
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: 4),
                      _buildStatusBadge(payment.status),
                    ],
                  ),
                ],
              ),
              if (payment.transactionId != null) ...[
                const SizedBox(height: 8),
                Text(
                  'Txn: ${payment.transactionId}',
                  style: TextStyle(
                    color: Colors.grey[500],
                    fontSize: 11,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusBadge(PaymentStatus status) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: _getStatusColor(status).withAlpha(25),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status.name.toUpperCase(),
        style: TextStyle(
          color: _getStatusColor(status),
          fontSize: 10,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Color _getStatusColor(PaymentStatus status) {
    switch (status) {
      case PaymentStatus.paid:
        return AppTheme.successColor;
      case PaymentStatus.pending:
        return AppTheme.warningColor;
      case PaymentStatus.processing:
        return AppTheme.processingColor;
    }
  }

  void _showPaymentDetails(BuildContext context, PaymentHistory payment) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: AppTheme.primaryColor.withAlpha(25),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Center(
                      child: Text(
                        Formatters.getInitials(payment.employeeName),
                        style: TextStyle(
                          color: AppTheme.primaryColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
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
                          payment.employeeName,
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        const SizedBox(height: 4),
                        _buildStatusBadge(payment.status),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              _buildDetailRow('Amount', Formatters.formatCurrency(payment.amount)),
              _buildDetailRow('Salary Month', Formatters.formatMonthYear(payment.salaryMonth)),
              _buildDetailRow('Payment Date', Formatters.formatDate(payment.paymentDate)),
              if (payment.transactionId != null)
                _buildDetailRow('Transaction ID', payment.transactionId!),
              if (payment.remarks != null)
                _buildDetailRow('Remarks', payment.remarks!),
              const SizedBox(height: 24),
              if (payment.status == PaymentStatus.pending)
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      context.read<SalaryProvider>().updatePaymentStatus(
                            payment.id,
                            PaymentStatus.processing,
                          );
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Payment marked as processing')),
                      );
                    },
                    child: const Text('Process Payment'),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.grey[600],
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
