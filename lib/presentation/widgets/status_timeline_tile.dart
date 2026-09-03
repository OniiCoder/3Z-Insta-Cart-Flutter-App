import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

class StatusTimelineTile extends StatelessWidget {
  final String title;
  final String description;
  final bool isCompleted;
  final bool isCurrent;
  final bool isLast;

  const StatusTimelineTile({
    super.key,
    required this.title,
    required this.description,
    required this.isCompleted,
    required this.isCurrent,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isCompleted
                    ? AppColors.primary
                    : isCurrent
                        ? AppColors.secondary
                        : Colors.grey.shade300,
                border: Border.all(
                  color: isCurrent ? AppColors.secondary.withOpacity(0.3) : Colors.transparent,
                  width: 3,
                ),
              ),
              child: Center(
                child: isCompleted
                    ? const Icon(Icons.check, size: 16, color: Colors.white)
                    : isCurrent
                        ? const SizedBox(
                            width: 12,
                            height: 12,
                            child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                          )
                        : const SizedBox.shrink(),
              ),
            ),
            if (!isLast)
              Container(
                width: 2,
                height: 48,
                color: isCompleted ? AppColors.primary : Colors.grey.shade300,
              ),
          ],
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: isCurrent || isCompleted ? FontWeight.w700 : FontWeight.w500,
                    color: isCurrent || isCompleted ? AppColors.textPrimary : AppColors.textMuted,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 12,
                    color: isCurrent ? AppColors.textSecondary : AppColors.textMuted,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
