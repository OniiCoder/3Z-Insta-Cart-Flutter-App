import 'package:flutter/material.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:threezinstacart/theme/bmn_theme.dart';
import 'package:threezinstacart/components/bmn_avatar.dart';

class BmnNotificationItem extends StatelessWidget {
  final String? title;
  final String? message;
  final Widget? child;
  final String time;
  final bool unread;
  final bool isFirst;
  final bool isLast;
  final VoidCallback? onClick;

  const BmnNotificationItem({
    super.key,
    this.title,
    this.message,
    this.child,
    required this.time,
    this.unread = false,
    this.isFirst = false,
    this.isLast = false,
    this.onClick,
  });

  @override
  Widget build(BuildContext context) {
    // Top radius if first item
    final borderRadius = isFirst
        ? const BorderRadius.vertical(top: Radius.circular(24))
        : null;

    final Widget unreadDot = Container(
      width: 8,
      height: 8,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: unread ? BmnColors.brandGreen700 : Colors.transparent,
      ),
    );

    const Widget avatar = BmnAvatar(
      size: BmnAvatarSize.sm,
      shape: BmnAvatarShape.circle,
      child: BmnAvatarIcon(
        icon: IconsaxPlusLinear.notification,
        color: BmnColors.gray400,
      ),
    );

    final Widget messageBody = RichText(
      text: TextSpan(
        style: const TextStyle(
          fontSize: 14,
          color: BmnColors.gray600,
          fontFamily: 'Matter',
          fontWeight: FontWeight.w500,
        ),
        children: [
          if (title != null) ...[
            TextSpan(
              text: '$title ',
              style: const TextStyle(
                color: BmnColors.gray800,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
          if (message != null) ...[
            TextSpan(text: message!),
          ],
        ],
      ),
    );

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: borderRadius,
        border: isLast
            ? null
            : const Border(
                bottom: BorderSide(
                  color: BmnColors.gray50,
                  width: 4,
                ),
              ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onClick,
          borderRadius: borderRadius,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                unreadDot,
                const SizedBox(width: 12),
                avatar,
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      child ?? messageBody,
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  time,
                  style: const TextStyle(
                    fontSize: 13,
                    color: BmnColors.gray600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
