import 'package:flutter/material.dart';
import 'package:threezinstacart/theme/bmn_theme.dart';

enum BmnRadioVariant {
  defaultVariant,
  card,
}

class BmnRadio extends StatelessWidget {
  final String? label;
  final bool checked;
  final ValueChanged<bool>? onChange;
  final bool disabled;
  final BmnRadioVariant variant;
  final Widget? icon;

  const BmnRadio({
    super.key,
    this.label,
    this.checked = false,
    this.onChange,
    this.disabled = false,
    this.variant = BmnRadioVariant.defaultVariant,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final bool isCard = variant == BmnRadioVariant.card;

    // Radio circle styling
    final Widget radioIndicator = AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      width: 20,
      height: 20,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
        border: Border.all(
          color: checked ? BmnColors.brandGreen500 : BmnColors.gray300,
          width: 1.5,
        ),
      ),
      child: Center(
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          width: checked ? 10 : 0,
          height: checked ? 10 : 0,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: BmnColors.brandGreen600,
          ),
        ),
      ),
    );

    // Build overall content
    Widget body = Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        radioIndicator,
        if (label != null) ...[
          const SizedBox(width: 8),
          isCard
              ? Expanded(
                  child: Text(
                    label!,
                    style: TextStyle(
                      color: checked ? BmnColors.brandGreen800 : BmnColors.gray800,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                )
              : Text(
                  label!,
                  style: const TextStyle(
                    color: BmnColors.gray800,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
        ],
        if (icon != null) ...[
          const SizedBox(width: 8),
          icon!,
        ],
      ],
    );

    if (isCard) {
      body = AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: checked ? BmnColors.brandGreen500 : BmnColors.gray200,
            width: checked ? 2 : 1,
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: body,
      );
    }

    return Opacity(
      opacity: disabled ? 0.5 : 1.0,
      child: GestureDetector(
        onTap: (disabled || onChange == null) ? null : () => onChange!(!checked),
        child: MouseRegion(
          cursor: disabled ? SystemMouseCursors.basic : SystemMouseCursors.click,
          child: body,
        ),
      ),
    );
  }
}
