import 'package:flutter/material.dart';
import 'package:threezinstacart/theme/bmn_theme.dart';

class BmnSettingsItem extends StatelessWidget {
  final String title;
  final String? description;
  final IconData icon;
  final Widget? children;
  final bool showSubtleSeparator;
  final bool showSectionSeparator;
  final BorderRadius? borderRadius;
  final VoidCallback? onTap;

  const BmnSettingsItem({
    super.key,
    required this.title,
    this.description,
    required this.icon,
    this.children,
    this.showSubtleSeparator = false,
    this.showSectionSeparator = true,
    this.borderRadius,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // Bottom border/separator logic
    BoxDecoration decoration;
    if (showSectionSeparator) {
      decoration = BoxDecoration(
        color: Colors.white,
        borderRadius: borderRadius,
        border: const Border(
          bottom: BorderSide(color: BmnColors.gray50, width: 4),
        ),
      );
    } else if (showSubtleSeparator) {
      decoration = BoxDecoration(
        color: Colors.white,
        borderRadius: borderRadius,
        border: const Border(
          bottom: BorderSide(color: BmnColors.gray100, width: 1),
        ),
      );
    } else {
      decoration = BoxDecoration(
        color: Colors.white,
        borderRadius: borderRadius,
      );
    }

    return Container(
      decoration: decoration,
      child: Material(
        color: Colors.transparent,
        borderRadius: borderRadius,
        child: InkWell(
          onTap: onTap,
          borderRadius: borderRadius,
          splashColor: BmnColors.gray50,
          highlightColor: BmnColors.gray100,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: BmnColors.gray50,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Icon(
                      icon,
                      color: BmnColors.brandGreen700,
                      size: 24,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: BmnColors.gray800,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (description != null) ...[
                        const SizedBox(height: 2),
                        Text(
                          description!,
                          style: const TextStyle(
                            fontSize: 14,
                            color: BmnColors.gray600,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ],
                  ),
                ),
                if (children != null) ...[
                  const SizedBox(width: 12),
                  children!,
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
