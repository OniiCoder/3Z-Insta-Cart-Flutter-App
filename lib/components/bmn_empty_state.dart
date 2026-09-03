import 'package:flutter/material.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:threezinstacart/theme/bmn_theme.dart';
import 'package:threezinstacart/components/bmn_button.dart';

class BmnEmptyState extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final String? ctaText;
  final IconData? ctaIcon;
  final bool hasCta;
  final VoidCallback? onCtaClick;

  const BmnEmptyState({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    this.ctaText,
    this.ctaIcon = IconsaxPlusLinear.add,
    this.hasCta = false,
    this.onCtaClick,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              decoration: const BoxDecoration(
                color: BmnColors.gray50,
                shape: BoxShape.circle,
              ),
              padding: const EdgeInsets.all(16),
              child: Icon(
                icon,
                size: 40,
                color: BmnColors.gray500,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: BmnColors.gray800,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              style: const TextStyle(
                fontSize: 14,
                color: BmnColors.gray600,
              ),
              textAlign: TextAlign.center,
            ),
            if (hasCta && ctaText != null) ...[
              const SizedBox(height: 24),
              BmnButton(
                variant: BmnButtonVariant.primary,
                icon: ctaIcon,
                text: ctaText,
                onPressed: onCtaClick,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
