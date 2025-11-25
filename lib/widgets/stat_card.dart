import 'package:flutter/material.dart';
import '../utils/formatters.dart';

class StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;
  final String? subtitle;
  final VoidCallback? onTap;
  final double? trend;

  const StatCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
    this.subtitle,
    this.onTap,
    this.trend,
  });

  factory StatCard.currency({
    Key? key,
    required String title,
    required double amount,
    required IconData icon,
    required Color color,
    String? subtitle,
    VoidCallback? onTap,
    double? trend,
  }) {
    return StatCard(
      key: key,
      title: title,
      value: Formatters.formatCompactCurrency(amount),
      icon: icon,
      color: color,
      subtitle: subtitle,
      onTap: onTap,
      trend: trend,
    );
  }

  factory StatCard.number({
    Key? key,
    required String title,
    required int count,
    required IconData icon,
    required Color color,
    String? subtitle,
    VoidCallback? onTap,
    double? trend,
  }) {
    return StatCard(
      key: key,
      title: title,
      value: count.toString(),
      icon: icon,
      color: color,
      subtitle: subtitle,
      onTap: onTap,
      trend: trend,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: color.withAlpha(25),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      icon,
                      color: color,
                      size: 24,
                    ),
                  ),
                  if (trend != null) _buildTrendIndicator(),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                value,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 4),
              Text(
                title,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 13,
                ),
              ),
              if (subtitle != null) ...[
                const SizedBox(height: 4),
                Text(
                  subtitle!,
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

  Widget _buildTrendIndicator() {
    final isPositive = (trend ?? 0) >= 0;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isPositive
            ? Colors.green.withAlpha(25)
            : Colors.red.withAlpha(25),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isPositive ? Icons.trending_up : Icons.trending_down,
            color: isPositive ? Colors.green : Colors.red,
            size: 16,
          ),
          const SizedBox(width: 4),
          Text(
            '${isPositive ? '+' : ''}${trend!.toStringAsFixed(1)}%',
            style: TextStyle(
              color: isPositive ? Colors.green : Colors.red,
              fontWeight: FontWeight.w500,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
