import 'package:flutter/material.dart';
import 'package:threezinstacart/theme/bmn_theme.dart';

enum BmnCheckboxVariant {
  defaultVariant,
  card,
}

class BmnCheckbox extends StatelessWidget {
  final String? label;
  final bool checked;
  final ValueChanged<bool>? onChange;
  final bool disabled;
  final BmnCheckboxVariant variant;
  final Widget? icon;
  final bool expanded;

  const BmnCheckbox({
    super.key,
    this.label,
    this.checked = false,
    this.onChange,
    this.disabled = false,
    this.variant = BmnCheckboxVariant.defaultVariant,
    this.icon,
    this.expanded = false,
  });

  @override
  Widget build(BuildContext context) {
    final bool isCard = variant == BmnCheckboxVariant.card;

    // Checkbox box styling
    final Widget checkboxBox = AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      width: 20,
      height: 20,
      decoration: BoxDecoration(
        color: checked ? BmnColors.brandGreen700 : Colors.white,
        borderRadius: BorderRadius.circular(5),
        border: Border.all(
          color: checked ? BmnColors.brandGreen500 : BmnColors.gray300,
          width: checked ? 2 : 1,
        ),
      ),
      child: checked
          ? const Center(
              child: Icon(
                Icons.check,
                size: 14,
                color: Colors.white,
              ),
            )
          : null,
    );

    // Build overall content
    Widget body = Row(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 2),
          child: checkboxBox,
        ),
        if (label != null) ...[
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              label!,
              style: TextStyle(
                color: isCard && checked ? BmnColors.brandGreen800 : BmnColors.gray800,
                fontSize: 13,
                fontWeight: FontWeight.w600,
                height: 1.35,
              ),
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
