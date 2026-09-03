import 'package:flutter/material.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:threezinstacart/theme/bmn_theme.dart';

class BmnChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback? onPressed;
  final bool disabled;
  final bool showTrailingIcon;

  const BmnChip({
    super.key,
    this.label = 'Chip',
    this.selected = false,
    this.onPressed,
    this.disabled = false,
    this.showTrailingIcon = true,
  });

  @override
  Widget build(BuildContext context) {
    final Color backgroundColor = selected ? BmnColors.brandGreen700 : BmnColors.gray100;
    final Color textColor = selected ? Colors.white : BmnColors.gray800;

    final Widget trailingIcon = Container(
      padding: const EdgeInsets.all(2),
      decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
      child: Icon(
        selected ? IconsaxPlusLinear.close_square : IconsaxPlusLinear.add,
        size: 16,
        color: BmnColors.gray900,
      ),
    );

    return Opacity(
      opacity: disabled ? 0.5 : 1.0,
      child: GestureDetector(
        onTap: disabled ? null : onPressed,
        child: MouseRegion(
          cursor: (!disabled && onPressed != null) ? SystemMouseCursors.click : SystemMouseCursors.basic,
          child: Container(
            height: 38,
            decoration: BoxDecoration(color: backgroundColor, borderRadius: BorderRadius.circular(999)),
            padding: const EdgeInsets.only(left: 14, right: 6, top: 4, bottom: 4),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  label,
                  style: TextStyle(color: textColor, fontSize: 14, fontWeight: FontWeight.w600),
                ),
                const SizedBox(width: 8),
                if (showTrailingIcon) trailingIcon,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
