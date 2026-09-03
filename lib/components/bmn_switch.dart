import 'package:flutter/material.dart';
import 'package:threezinstacart/theme/bmn_theme.dart';

class BmnSwitch extends StatelessWidget {
  final bool value;
  final ValueChanged<bool>? onChanged;
  final bool disabled;

  const BmnSwitch({
    super.key,
    required this.value,
    this.onChanged,
    this.disabled = false,
  });

  @override
  Widget build(BuildContext context) {
    final bool canTap = onChanged != null && !disabled;

    return Opacity(
      opacity: disabled ? 0.5 : 1.0,
      child: GestureDetector(
        onTap: canTap ? () => onChanged!(!value) : null,
        child: MouseRegion(
          cursor: canTap ? SystemMouseCursors.click : SystemMouseCursors.basic,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            width: 58,
            height: 32,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: value ? BmnColors.brandGreen600 : BmnColors.gray100,
            ),
            padding: const EdgeInsets.all(2),
            child: Stack(
              children: [
                AnimatedAlign(
                  duration: const Duration(milliseconds: 150),
                  alignment: value ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    width: 28,
                    height: 28,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 1,
                          offset: Offset(0, 1),
                        ),
                      ],
                    ),
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
