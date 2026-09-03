import 'package:flutter/material.dart';
import 'package:threezinstacart/theme/bmn_theme.dart';
import 'package:threezinstacart/components/bmn_avatar.dart';

class BmnAvatarLabel extends StatelessWidget {
  final String name;
  final String initials;
  final String? imageSrc;
  final bool selected;
  final bool disabled;
  final VoidCallback? onSelect;

  const BmnAvatarLabel({
    super.key,
    this.name = 'John Doe',
    this.initials = 'JD',
    this.imageSrc,
    this.selected = false,
    this.disabled = false,
    this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    Color backgroundColor = BmnColors.gray50;
    Color textColor = BmnColors.gray700;
    Border? border;

    if (selected) {
      backgroundColor = BmnColors.brandGreen50;
      textColor = BmnColors.brandGreen800;
      border = Border.all(color: BmnColors.brandGreen500, width: 2);
    }

    final Widget avatar = BmnAvatar(
      size: BmnAvatarSize.xs,
      shape: BmnAvatarShape.circle,
      child: imageSrc != null
          ? BmnAvatarImage(src: imageSrc!)
          : BmnAvatarInitials(initials: initials, color: selected ? BmnColors.brandGreen800 : BmnColors.gray800),
    );

    return Opacity(
      opacity: disabled ? 0.5 : 1.0,
      child: GestureDetector(
        onTap: disabled ? null : onSelect,
        child: MouseRegion(
          cursor: (onSelect != null && !disabled)
              ? SystemMouseCursors.click
              : SystemMouseCursors.basic,
          child: Container(
            height: 38,
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(999),
              border: border,
            ),
            padding: const EdgeInsets.only(left: 4, right: 12, top: 3, bottom: 3),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                avatar,
                const SizedBox(width: 8),
                Text(
                  name,
                  style: TextStyle(
                    color: textColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
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
