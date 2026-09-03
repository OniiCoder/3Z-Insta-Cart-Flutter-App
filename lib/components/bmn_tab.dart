import 'package:flutter/material.dart';
import 'package:threezinstacart/theme/bmn_theme.dart';

class BmnTab extends StatelessWidget {
  final String title;
  final int? count;
  final bool isActive;
  final VoidCallback onClick;

  const BmnTab({
    super.key,
    required this.title,
    this.count,
    this.isActive = false,
    required this.onClick,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onClick,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: Container(
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: isActive ? BmnColors.brandGreen500 : Colors.transparent,
                width: 2,
              ),
            ),
          ),
          padding: const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 12),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (count != null) ...[
                Container(
                  decoration: BoxDecoration(
                    color: BmnColors.gray200.withAlpha(128),
                    shape: BoxShape.circle,
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  child: Text(
                    count!.toString(),
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: BmnColors.gray800,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
              ],
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: isActive ? BmnColors.gray800 : BmnColors.gray500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
