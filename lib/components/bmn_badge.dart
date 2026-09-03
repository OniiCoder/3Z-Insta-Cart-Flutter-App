import 'package:flutter/material.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:threezinstacart/theme/bmn_theme.dart';

enum BmnBadgeVariant {
  defaultVariant,
  info,
  success,
  warning,
  error,
  primary,
  danger,
}

class BmnBadge extends StatelessWidget {
  final String label;
  final BmnBadgeVariant variant;
  final IconData? icon;

  const BmnBadge({
    super.key,
    this.label = 'New',
    this.variant = BmnBadgeVariant.defaultVariant,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    Color backgroundColor;
    Color textColor;
    Color borderColor;
    IconData defaultIcon;
    Color iconColor;

    switch (variant) {
      case BmnBadgeVariant.defaultVariant:
        backgroundColor = BmnColors.gray50;
        textColor = BmnColors.gray700;
        borderColor = BmnColors.gray200;
        defaultIcon = IconsaxPlusLinear.info_circle;
        iconColor = BmnColors.gray400;
        break;
      case BmnBadgeVariant.info:
      case BmnBadgeVariant.primary:
        backgroundColor = BmnColors.blue50;
        textColor = BmnColors.blue700;
        borderColor = BmnColors.blue200;
        defaultIcon = IconsaxPlusLinear.info_circle;
        iconColor = BmnColors.blue400;
        break;
      case BmnBadgeVariant.success:
        backgroundColor = const Color(0xFFE5FFF5); // green50
        textColor = const Color(0xFF216E4E); // green700
        borderColor = const Color(0xFFBAF3DB); // green200
        defaultIcon = IconsaxPlusLinear.tick_circle;
        iconColor = const Color(0xFF4BCE97); // green300
        break;
      case BmnBadgeVariant.warning:
        backgroundColor = BmnColors.orange50;
        textColor = BmnColors.orange700;
        borderColor = BmnColors.orange200;
        defaultIcon = IconsaxPlusLinear.danger;
        iconColor = BmnColors.orange400;
        break;
      case BmnBadgeVariant.error:
      case BmnBadgeVariant.danger:
        backgroundColor = BmnColors.red50;
        textColor = BmnColors.red700;
        borderColor = BmnColors.red200;
        defaultIcon = IconsaxPlusLinear.close_circle;
        iconColor = BmnColors.red400;
        break;
    }

    final IconData resolvedIcon = icon ?? defaultIcon;

    return Container(
      height: 32,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: borderColor, width: 1),
      ),
      padding: const EdgeInsets.only(left: 8, right: 12),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            resolvedIcon,
            size: 20,
            color: iconColor,
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(
              color: textColor,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
