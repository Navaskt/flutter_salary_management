import 'package:flutter/material.dart';
import '../models/deduction.dart';
import '../utils/formatters.dart';

class DeductionItem extends StatelessWidget {
  final Deduction deduction;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final bool isEditable;

  const DeductionItem({
    super.key,
    required this.deduction,
    this.onEdit,
    this.onDelete,
    this.isEditable = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.withAlpha(51)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: _getTypeColor().withAlpha(25),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              _getTypeIcon(),
              color: _getTypeColor(),
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  deduction.name,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                ),
                const SizedBox(height: 2),
                Text(
                  deduction.typeDisplayName,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Text(
            '- ${Formatters.formatCurrency(deduction.amount)}',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Colors.red[700],
                  fontWeight: FontWeight.bold,
                ),
          ),
          if (isEditable) ...[
            const SizedBox(width: 8),
            IconButton(
              icon: const Icon(Icons.edit, size: 18),
              onPressed: onEdit,
              color: Colors.grey[600],
              constraints: const BoxConstraints(
                minWidth: 32,
                minHeight: 32,
              ),
              padding: EdgeInsets.zero,
            ),
            IconButton(
              icon: const Icon(Icons.delete, size: 18),
              onPressed: onDelete,
              color: Colors.red[400],
              constraints: const BoxConstraints(
                minWidth: 32,
                minHeight: 32,
              ),
              padding: EdgeInsets.zero,
            ),
          ],
        ],
      ),
    );
  }

  Color _getTypeColor() {
    switch (deduction.type) {
      case DeductionType.tax:
        return Colors.orange;
      case DeductionType.pf:
        return Colors.blue;
      case DeductionType.insurance:
        return Colors.purple;
      case DeductionType.loan:
        return Colors.red;
      case DeductionType.other:
        return Colors.grey;
    }
  }

  IconData _getTypeIcon() {
    switch (deduction.type) {
      case DeductionType.tax:
        return Icons.receipt_long;
      case DeductionType.pf:
        return Icons.savings;
      case DeductionType.insurance:
        return Icons.health_and_safety;
      case DeductionType.loan:
        return Icons.account_balance;
      case DeductionType.other:
        return Icons.remove_circle_outline;
    }
  }
}
