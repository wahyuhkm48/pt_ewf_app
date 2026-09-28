// widgets/level_row.dart
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class LevelRow extends StatelessWidget {
  final String label;
  final String value;
  final Color dotColor;
  final bool isMidpoint;
  final bool isFirst;

  const LevelRow({
    super.key,
    required this.label,
    required this.value,
    required this.dotColor,
    this.isMidpoint = false,
    this.isFirst = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
      decoration: BoxDecoration(
        border: isFirst ? null : const Border(top: BorderSide(color: AppColors.divider, width: 0.5)),
      ),
      child: Row(
        children: [
          Container(width: 8, height: 8, decoration: BoxDecoration(color: dotColor, shape: BoxShape.circle)),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontSize: isMidpoint ? 12 : 14,
                fontWeight: isMidpoint ? FontWeight.w400 : FontWeight.w600,
                color: isMidpoint ? AppColors.textSecondary : AppColors.textPrimary,
                fontStyle: isMidpoint ? FontStyle.italic : FontStyle.normal,
              ),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: isMidpoint ? 13 : 15,
              fontWeight: FontWeight.bold,
              color: isMidpoint ? AppColors.textSecondary : AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}