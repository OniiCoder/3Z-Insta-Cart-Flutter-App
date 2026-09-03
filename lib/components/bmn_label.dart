import 'package:flutter/material.dart';
import 'package:threezinstacart/theme/bmn_theme.dart';

class BmnLabel extends StatelessWidget {
  final String text;
  final bool selected;
  final bool disabled;
  final VoidCallback? onSelect;

  const BmnLabel({
    super.key,
    this.text = 'Label',
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

    return Opacity(
      opacity: disabled ? 0.5 : 1.0,
      child: GestureDetector(
        onTap: disabled ? null : onSelect,
        child: MouseRegion(
          cursor: (onSelect != null && !disabled)
              ? SystemMouseCursors.click
              : SystemMouseCursors.basic,
          child: Container(
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(12),
              border: border,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Text(
              text,
              style: TextStyle(
                color: textColor,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
