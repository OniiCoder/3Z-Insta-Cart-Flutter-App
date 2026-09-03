import 'package:flutter/material.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:threezinstacart/theme/bmn_theme.dart';

enum BmnButtonVariant {
  primary,
  secondary,
  ghost,
  outline,
  outlineLight,
  white,
  danger,
  dangerGhost,
}

enum BmnButtonSize {
  sm,
  defaultSize,
  lg,
  icon,
  iconSm,
  iconLg,
}

class BmnButton extends StatelessWidget {
  final BmnButtonVariant variant;
  final BmnButtonSize size;
  final IconData? icon;
  final double? iconSize;
  final String? text;
  final Widget? child;
  final bool processing;
  final VoidCallback? onPressed;
  final bool disabled;
  final double? width;
  final Color? customTextColor;
  final Color? customBackgroundColor;
  final Color? customBorderColor;

  const BmnButton({
    super.key,
    this.variant = BmnButtonVariant.primary,
    this.size = BmnButtonSize.defaultSize,
    this.icon,
    this.iconSize,
    this.text,
    this.child,
    this.processing = false,
    this.onPressed,
    this.disabled = false,
    this.width,
    this.customTextColor,
    this.customBackgroundColor,
    this.customBorderColor,
  });

  @override
  Widget build(BuildContext context) {
    final isBtnDisabled = disabled || processing || onPressed == null;

    // Get Variant Colors
    Color backgroundColor;
    Color textColor;
    BorderSide borderSide = BorderSide.none;

    switch (variant) {
      case BmnButtonVariant.primary:
        backgroundColor = BmnColors.brandGreen600;
        textColor = Colors.white;
        break;
      case BmnButtonVariant.secondary:
        backgroundColor = BmnColors.brandGreen50;
        textColor = BmnColors.brandGreen700;
        break;
      case BmnButtonVariant.white:
        backgroundColor = Colors.white;
        textColor = BmnColors.brandGreen800;
        break;
      case BmnButtonVariant.ghost:
        backgroundColor = BmnColors.gray100;
        textColor = BmnColors.gray800;
        break;
      case BmnButtonVariant.outline:
        backgroundColor = Colors.transparent;
        textColor = BmnColors.gray800;
        borderSide = const BorderSide(color: BmnColors.gray300, width: 1);
        break;
      case BmnButtonVariant.outlineLight:
        backgroundColor = Colors.white.withValues(alpha: 0.15);
        textColor = Colors.white;
        borderSide = BorderSide(color: Colors.white.withValues(alpha: 0.4), width: 1.5);
        break;
      case BmnButtonVariant.danger:
        backgroundColor = BmnColors.red600;
        textColor = Colors.white;
        break;
      case BmnButtonVariant.dangerGhost:
        backgroundColor = BmnColors.red50;
        textColor = BmnColors.red500;
        break;
    }

    if (customBackgroundColor != null) backgroundColor = customBackgroundColor!;
    if (customTextColor != null) textColor = customTextColor!;
    if (customBorderColor != null) borderSide = BorderSide(color: customBorderColor!, width: 1.5);

    // Get Size Specifications
    double height;
    double paddingHorizontal;
    double borderRadiusVal;
    double fontSize;
    double resolvedIconSize;

    switch (size) {
      case BmnButtonSize.sm:
        height = 32;
        paddingHorizontal = 12;
        borderRadiusVal = 12;
        fontSize = 14;
        resolvedIconSize = 16;
        break;
      case BmnButtonSize.defaultSize:
        height = 44;
        paddingHorizontal = 16;
        borderRadiusVal = 16;
        fontSize = 14;
        resolvedIconSize = 20;
        break;
      case BmnButtonSize.lg:
        height = 52;
        paddingHorizontal = 24;
        borderRadiusVal = 16;
        fontSize = 18;
        resolvedIconSize = 24;
        break;
      case BmnButtonSize.iconSm:
        height = 32;
        paddingHorizontal = 0;
        borderRadiusVal = 12;
        fontSize = 14;
        resolvedIconSize = 16;
        break;
      case BmnButtonSize.icon:
        height = 44;
        paddingHorizontal = 0;
        borderRadiusVal = 16;
        fontSize = 14;
        resolvedIconSize = 20;
        break;
      case BmnButtonSize.iconLg:
        height = 52;
        paddingHorizontal = 0;
        borderRadiusVal = 16;
        fontSize = 18;
        resolvedIconSize = 24;
        break;
    }

    final isIconOnly = size == BmnButtonSize.icon ||
        size == BmnButtonSize.iconSm ||
        size == BmnButtonSize.iconLg;

    // Content builder
    Widget contentWidget;
    if (processing) {
      contentWidget = _BmnSpinner(
        size: resolvedIconSize,
        color: textColor,
      );
    } else {
      final iconWidget = icon != null
          ? Icon(
              icon,
              size: iconSize ?? resolvedIconSize,
              color: textColor,
            )
          : null;

      if (isIconOnly) {
        contentWidget = iconWidget ?? const SizedBox.shrink();
      } else {
        final textWidget = child ??
            Text(
              text ?? '',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.w600,
                color: textColor,
              ),
            );

        contentWidget = FittedBox(
          fit: BoxFit.scaleDown,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (iconWidget != null) ...[
                iconWidget,
                const SizedBox(width: 8),
              ],
              textWidget,
            ],
          ),
        );
      }
    }

    return Opacity(
      opacity: isBtnDisabled ? 0.5 : 1.0,
      child: Container(
        width: width ?? (isIconOnly ? height : null),
        height: height,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(borderRadiusVal),
          border: borderSide != BorderSide.none
              ? Border.fromBorderSide(borderSide)
              : null,
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(borderRadiusVal),
            onTap: isBtnDisabled ? null : onPressed,
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: isIconOnly ? 0 : paddingHorizontal,
              ),
              child: Center(
                child: contentWidget,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _BmnSpinner extends StatefulWidget {
  final double size;
  final Color color;

  const _BmnSpinner({required this.size, required this.color});

  @override
  State<_BmnSpinner> createState() => _BmnSpinnerState();
}

class _BmnSpinnerState extends State<_BmnSpinner>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RotationTransition(
      turns: _controller,
      child: Icon(
        IconsaxPlusLinear.refresh,
        size: widget.size,
        color: widget.color,
      ),
    );
  }
}
