import 'package:flutter/material.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:threezinstacart/theme/bmn_theme.dart';

enum BmnAlertVariant { defaultVariant, info, success, warning, error }

class BmnAlert extends StatelessWidget {
  final BmnAlertVariant variant;
  final String? title;
  final String? message;
  final Widget? description;
  final bool dismissible;
  final VoidCallback? onDismiss;
  final Widget? child;

  const BmnAlert({
    super.key,
    this.variant = BmnAlertVariant.defaultVariant,
    this.title,
    this.message,
    this.description,
    this.dismissible = false,
    this.onDismiss,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    Color backgroundColor;
    Color borderColor;
    Color titleColor;
    Color messageColor;
    IconData iconData;
    Color iconColor;

    switch (variant) {
      case BmnAlertVariant.defaultVariant:
        backgroundColor = BmnColors.gray50;
        borderColor = BmnColors.gray200;
        titleColor = BmnColors.gray800;
        messageColor = BmnColors.gray600;
        iconData = IconsaxPlusLinear.info_circle;
        iconColor = BmnColors.gray400;
        break;
      case BmnAlertVariant.info:
        backgroundColor = BmnColors.blue50;
        borderColor = BmnColors.blue100;
        titleColor = BmnColors.blue800;
        messageColor = BmnColors.blue600;
        iconData = IconsaxPlusLinear.info_circle;
        iconColor = BmnColors.blue400;
        break;
      case BmnAlertVariant.success:
        backgroundColor = const Color(0xFFE5FFF5); // green50
        borderColor = const Color(0xFFBAF3DB); // green200
        titleColor = const Color(0xFF216E4E); // green700
        messageColor = const Color(0xFF1F845A); // green600
        iconData = IconsaxPlusLinear.tick_circle;
        iconColor = const Color(0xFF4BCE97); // green300
        break;
      case BmnAlertVariant.warning:
        backgroundColor = BmnColors.orange50;
        borderColor = BmnColors.orange200;
        titleColor = BmnColors.orange800;
        messageColor = BmnColors.orange600;
        iconData = IconsaxPlusLinear.danger;
        iconColor = BmnColors.orange400;
        break;
      case BmnAlertVariant.error:
        backgroundColor = BmnColors.red50;
        borderColor = BmnColors.red200;
        titleColor = BmnColors.red800;
        messageColor = BmnColors.red600;
        iconData = IconsaxPlusLinear.close_circle;
        iconColor = BmnColors.red400;
        break;
    }

    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        border: Border.all(color: borderColor, width: 2),
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(iconData, size: 20, color: iconColor),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (title != null) ...[
                  Text(
                    title!,
                    style: TextStyle(color: titleColor, fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 2),
                ],
                if (message != null) ...[
                  Text(
                    message!,
                    style: TextStyle(color: messageColor, fontSize: 14, fontWeight: FontWeight.w500),
                  ),
                ],
                if (description != null) ...[
                  DefaultTextStyle(
                    style: TextStyle(color: messageColor, fontSize: 14, fontWeight: FontWeight.w500),
                    child: description!,
                  ),
                ],
                if (child != null) child as Widget,
              ],
            ),
          ),
          if (dismissible) ...[
            const SizedBox(width: 8),
            GestureDetector(
              onTap: onDismiss,
              child: MouseRegion(
                cursor: SystemMouseCursors.click,
                child: Opacity(opacity: 0.6, child: Icon(IconsaxPlusLinear.close_circle, size: 20, color: titleColor)),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
