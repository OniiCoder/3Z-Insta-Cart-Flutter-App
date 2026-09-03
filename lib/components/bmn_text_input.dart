import 'package:flutter/material.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:threezinstacart/theme/bmn_theme.dart';

class BmnTextInput extends StatefulWidget {
  final String? label;
  final String? initialValue;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final String? placeholder;
  final String? error;
  final String? hintText;
  final Widget? startContent;
  final Widget? endContent;
  final bool isPassword;
  final bool required;
  final bool disabled;
  final TextInputType keyboardType;
  final int? maxLength;
  final FocusNode? focusNode;
  final TextStyle? style;
  final TextAlign textAlign;

  const BmnTextInput({
    super.key,
    this.label,
    this.initialValue,
    this.controller,
    this.onChanged,
    this.placeholder,
    this.error,
    this.hintText,
    this.startContent,
    this.endContent,
    this.isPassword = false,
    this.required = false,
    this.disabled = false,
    this.keyboardType = TextInputType.text,
    this.maxLength,
    this.focusNode,
    this.style,
    this.textAlign = TextAlign.start,
  });

  @override
  State<BmnTextInput> createState() => _BmnTextInputState();
}

class _BmnTextInputState extends State<BmnTextInput> {
  late FocusNode _focusNode;
  late TextEditingController _controller;
  bool _isFocused = false;
  bool _obscureText = true;

  @override
  void initState() {
    super.initState();
    _focusNode = widget.focusNode ?? FocusNode();
    _focusNode.addListener(_onFocusChange);
    _controller = widget.controller ?? TextEditingController(text: widget.initialValue);
    _obscureText = widget.isPassword;
  }

  @override
  void didUpdateWidget(covariant BmnTextInput oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller == null && widget.initialValue != oldWidget.initialValue) {
      _controller.text = widget.initialValue ?? '';
    }
  }

  @override
  void dispose() {
    if (widget.focusNode == null) {
      _focusNode.dispose();
    } else {
      _focusNode.removeListener(_onFocusChange);
    }
    if (widget.controller == null) {
      _controller.dispose();
    }
    super.dispose();
  }

  void _onFocusChange() {
    setState(() {
      _isFocused = _focusNode.hasFocus;
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool hasError = widget.error != null;

    // Define border width and color
    double borderWidth = 1.0;
    Color borderColor = BmnColors.gray400;
    List<BoxShadow>? boxShadow;

    if (hasError) {
      borderColor = BmnColors.red500;
      if (_isFocused) {
        boxShadow = const [
          BoxShadow(
            color: BmnColors.red500,
            spreadRadius: 2.0,
            blurRadius: 0,
          ),
        ];
      }
    } else if (_isFocused) {
      borderColor = BmnColors.brandGreen500;
      boxShadow = [
        BoxShadow(
          color: BmnColors.brandGreen500,
          spreadRadius: 2.0,
          blurRadius: 0,
        ),
      ];
    }

    return Opacity(
      opacity: widget.disabled ? 0.6 : 1.0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (widget.label != null) ...[
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  widget.label!,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: BmnColors.gray800,
                  ),
                ),
                if (widget.required) ...[
                  const SizedBox(width: 4),
                  const Text(
                    '*',
                    style: TextStyle(
                      color: BmnColors.red500,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 8),
          ],
          AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            height: 48,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: borderColor,
                width: borderWidth,
              ),
              boxShadow: boxShadow,
              color: widget.disabled ? BmnColors.gray50 : Colors.white,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (widget.startContent != null) ...[
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: widget.startContent!,
                  ),
                ],
                Expanded(
                  child: Center(
                    child: TextField(
                      focusNode: _focusNode,
                      controller: _controller,
                      onChanged: widget.onChanged,
                      enabled: !widget.disabled,
                      obscureText: _obscureText,
                      keyboardType: widget.keyboardType,
                      maxLength: widget.maxLength,
                      textAlign: widget.textAlign,
                      textAlignVertical: TextAlignVertical.center,
                      style: widget.style ??
                          const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: BmnColors.gray800,
                            height: 1.2,
                          ),
                      decoration: InputDecoration(
                        isDense: true,
                        isCollapsed: true,
                        hintText: widget.placeholder,
                        hintStyle: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: BmnColors.gray500,
                          height: 1.2,
                        ),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
                        counterText: '',
                      ),
                    ),
                  ),
                ),
                if (widget.isPassword) ...[
                  IconButton(
                    onPressed: widget.disabled
                        ? null
                        : () => setState(() => _obscureText = !_obscureText),
                    icon: Icon(
                      _obscureText
                          ? IconsaxPlusLinear.eye_slash
                          : IconsaxPlusLinear.eye,
                      size: 20,
                      color: BmnColors.gray500,
                    ),
                  ),
                ] else if (widget.endContent != null) ...[
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: widget.endContent!,
                  ),
                ],
              ],
            ),
          ),
          if (hasError) ...[
            const SizedBox(height: 4),
            Padding(
              padding: const EdgeInsets.only(left: 4.0),
              child: Text(
                widget.error!,
                style: const TextStyle(
                  color: BmnColors.red600,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ] else if (widget.hintText != null) ...[
            const SizedBox(height: 4),
            Padding(
              padding: const EdgeInsets.only(left: 4.0),
              child: Text(
                widget.hintText!,
                style: const TextStyle(
                  color: BmnColors.gray600,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
