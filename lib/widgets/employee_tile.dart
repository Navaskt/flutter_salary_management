import 'package:flutter/material.dart';
import '../models/employee.dart';
import '../utils/formatters.dart';
import '../config/theme.dart';

class EmployeeTile extends StatelessWidget {
  final Employee employee;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final bool showSalary;

  const EmployeeTile({
    super.key,
    required this.employee,
    this.onTap,
    this.onEdit,
    this.onDelete,
    this.showSalary = true,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              _buildAvatar(context),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            employee.name,
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (!employee.isActive)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.red.withAlpha(25),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Text(
                              'Inactive',
                              style: TextStyle(
                                color: Colors.red,
                                fontSize: 10,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${employee.designation} • ${employee.department}',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 13,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        _buildInfoChip(
                          Icons.badge_outlined,
                          employee.employeeId,
                        ),
                        const SizedBox(width: 12),
                        if (showSalary)
                          _buildInfoChip(
                            Icons.attach_money,
                            Formatters.formatCompactCurrency(employee.basicSalary),
                            color: AppTheme.successColor,
                          ),
                      ],
                    ),
                  ],
                ),
              ),
              if (onEdit != null || onDelete != null)
                PopupMenuButton<String>(
                  icon: Icon(Icons.more_vert, color: Colors.grey[600]),
                  onSelected: (value) {
                    if (value == 'edit' && onEdit != null) {
                      onEdit!();
                    } else if (value == 'delete' && onDelete != null) {
                      onDelete!();
                    }
                  },
                  itemBuilder: (context) => [
                    if (onEdit != null)
                      const PopupMenuItem(
                        value: 'edit',
                        child: Row(
                          children: [
                            Icon(Icons.edit, size: 20),
                            SizedBox(width: 8),
                            Text('Edit'),
                          ],
                        ),
                      ),
                    if (onDelete != null)
                      const PopupMenuItem(
                        value: 'delete',
                        child: Row(
                          children: [
                            Icon(Icons.delete, size: 20, color: Colors.red),
                            SizedBox(width: 8),
                            Text('Delete', style: TextStyle(color: Colors.red)),
                          ],
                        ),
                      ),
                  ],
                )
              else
                Icon(Icons.chevron_right, color: Colors.grey[400]),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAvatar(BuildContext context) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        color: AppTheme.primaryColor.withAlpha(25),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: Text(
          Formatters.getInitials(employee.name),
          style: TextStyle(
            color: AppTheme.primaryColor,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String text, {Color? color}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: 14,
          color: color ?? Colors.grey[500],
        ),
        const SizedBox(width: 4),
        Text(
          text,
          style: TextStyle(
            color: color ?? Colors.grey[600],
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
