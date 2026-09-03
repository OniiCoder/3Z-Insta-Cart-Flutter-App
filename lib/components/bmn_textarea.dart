import 'package:flutter/material.dart';
import 'package:threezinstacart/theme/bmn_theme.dart';

class BmnTextarea extends StatefulWidget {
  final String? label;
  final String? initialValue;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final String? placeholder;
  final String? error;
  final int rows;
  final bool disabled;
  final FocusNode? focusNode;

  const BmnTextarea({
    super.key,
    this.label,
    this.initialValue,
    this.controller,
    this.onChanged,
    this.placeholder,
    this.error,
    this.rows = 4,
    this.disabled = false,
    this.focusNode,
  });

  @override
  State<BmnTextarea> createState() => _BmnTextareaState();
}

class _BmnTextareaState extends State<BmnTextarea> {
  late FocusNode _focusNode;
  late TextEditingController _controller;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _focusNode = widget.focusNode ?? FocusNode();
    _focusNode.addListener(_onFocusChange);
    _controller = widget.controller ?? TextEditingController(text: widget.initialValue);
  }

  @override
  void didUpdateWidget(covariant BmnTextarea oldWidget) {
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

    double borderWidth = 1.0;
    Color borderColor = BmnColors.gray400;
    List<BoxShadow>? boxShadow;

    if (hasError) {
      borderColor = BmnColors.red500;
      if (_isFocused) {
        boxShadow = const [
          BoxShadow(
            color: BmnColors.red500,
            spreadRadius: 1.0,
            blurRadius: 0,
          ),
        ];
      }
    } else if (_isFocused) {
      borderColor = BmnColors.brandGreen500;
      boxShadow = [
        BoxShadow(
          color: BmnColors.brandGreen500,
          spreadRadius: 1.0,
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
            Text(
              widget.label!,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: BmnColors.gray800,
              ),
            ),
            const SizedBox(height: 8),
          ],
          AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            constraints: const BoxConstraints(minHeight: 100),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: borderColor,
                width: borderWidth,
              ),
              boxShadow: boxShadow,
              color: widget.disabled ? BmnColors.gray50 : Colors.white,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
            child: TextField(
              focusNode: _focusNode,
              controller: _controller,
              onChanged: widget.onChanged,
              enabled: !widget.disabled,
              maxLines: widget.rows,
              minLines: widget.rows,
              keyboardType: TextInputType.multiline,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: BmnColors.gray800,
              ),
              decoration: InputDecoration(
                hintText: widget.placeholder,
                hintStyle: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: BmnColors.gray500,
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              ),
            ),
          ),
          if (hasError) ...[
            const SizedBox(height: 4),
            Padding(
              padding: const EdgeInsets.only(left: 4.0),
              child: Text(
                widget.error!,
                style: const TextStyle(
                  color: BmnColors.red500,
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
