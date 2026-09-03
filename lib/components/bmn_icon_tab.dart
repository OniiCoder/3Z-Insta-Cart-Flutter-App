import 'package:flutter/material.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:threezinstacart/theme/bmn_theme.dart';

enum BmnIconTabVariant {
  icon,
  text,
  iconText,
}

class BmnIconTabOption {
  final String value;
  final String label;
  final IconData? icon;

  const BmnIconTabOption({
    required this.value,
    required this.label,
    this.icon,
  });
}

class BmnIconTab extends StatelessWidget {
  final String value;
  final ValueChanged<String>? onValueChange;
  final List<BmnIconTabOption>? options;
  final BmnIconTabVariant variant;

  const BmnIconTab({
    super.key,
    required this.value,
    this.onValueChange,
    this.options,
    this.variant = BmnIconTabVariant.icon,
  });

  static const List<BmnIconTabOption> _defaultOptions = [
    BmnIconTabOption(
      value: 'list',
      label: 'List view',
      icon: IconsaxPlusLinear.textalign_justifyleft,
    ),
    BmnIconTabOption(
      value: 'grid',
      label: 'Grid view',
      icon: IconsaxPlusLinear.element_3,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final listOptions = options ?? _defaultOptions;

    return Container(
      height: 44,
      decoration: BoxDecoration(
        color: BmnColors.gray100,
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(4),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: listOptions.map((opt) {
          final isSelected = opt.value == value;
          final bool showIcon = variant != BmnIconTabVariant.text && opt.icon != null;
          final bool showText = variant != BmnIconTabVariant.icon;

          Widget content;
          if (showIcon && showText) {
            content = Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(opt.icon, size: 20, color: isSelected ? BmnColors.brandGreen700 : BmnColors.gray600),
                const SizedBox(width: 8),
                Text(
                  opt.label,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: isSelected ? BmnColors.brandGreen700 : BmnColors.gray600,
                  ),
                ),
              ],
            );
          } else if (showIcon) {
            content = Icon(
              opt.icon,
              size: 20,
              color: isSelected ? BmnColors.brandGreen700 : BmnColors.gray600,
            );
          } else {
            content = Text(
              opt.label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: isSelected ? BmnColors.brandGreen700 : BmnColors.gray600,
              ),
            );
          }

          double? buttonWidth;
          if (variant == BmnIconTabVariant.icon) {
            buttonWidth = 36;
          }

          return GestureDetector(
            onTap: onValueChange == null ? null : () => onValueChange!(opt.value),
            child: MouseRegion(
              cursor: SystemMouseCursors.click,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                height: 36,
                width: buttonWidth,
                decoration: BoxDecoration(
                  color: isSelected ? Colors.white : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: isSelected
                      ? const [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 1,
                            offset: Offset(0, 1),
                          ),
                        ]
                      : null,
                ),
                padding: variant == BmnIconTabVariant.icon
                    ? EdgeInsets.zero
                    : const EdgeInsets.symmetric(horizontal: 12),
                child: Center(
                  child: content,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
