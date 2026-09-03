import 'package:flutter/material.dart';
import 'package:threezinstacart/theme/bmn_theme.dart';

class DetailItem extends StatelessWidget {
  final String label;
  final String value;
  final String? valueHref;
  final VoidCallback? onTap;

  const DetailItem({
    super.key,
    required this.label,
    required this.value,
    this.valueHref,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bool isLink = valueHref != null || onTap != null;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: BmnColors.gray600,
            ),
          ),
          const SizedBox(height: 4),
          GestureDetector(
            onTap: onTap,
            child: MouseRegion(
              cursor: isLink ? SystemMouseCursors.click : SystemMouseCursors.basic,
              child: Text(
                value,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: isLink ? BmnColors.brandGreen700 : BmnColors.gray800,
                  decoration: isLink ? TextDecoration.underline : null,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
