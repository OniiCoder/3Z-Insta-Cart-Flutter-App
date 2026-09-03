import 'package:flutter/material.dart';
import 'package:threezinstacart/theme/bmn_theme.dart';
import 'package:threezinstacart/components/bmn_button.dart';

class BmnFormWrapperContainer extends StatelessWidget {
  final Widget child;

  const BmnFormWrapperContainer({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 674),
        child: Padding(padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24), child: child),
      ),
    );
  }
}

class BmnFormWrapper extends StatelessWidget {
  final Widget child;

  const BmnFormWrapper({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: BmnColors.gray50, borderRadius: BorderRadius.circular(24)),
      padding: const EdgeInsets.only(left: 1, right: 1, top: 1, bottom: 4),
      child: child,
    );
  }
}

class BmnFormWrapperContent extends StatelessWidget {
  final List<Widget> children;
  final CrossAxisAlignment crossAxisAlignment;

  const BmnFormWrapperContent({
    super.key,
    required this.children,
    this.crossAxisAlignment = CrossAxisAlignment.stretch,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: BoxBorder.all(color: BmnColors.gray50, width: 2.0),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: crossAxisAlignment,
        mainAxisSize: MainAxisSize.min,
        children: children.expand((w) => [w, const SizedBox(height: 16)]).toList()..removeLast(),
      ),
    );
  }
}

class BmnFormWrapperFooter extends StatelessWidget {
  final List<Widget> children;

  const BmnFormWrapperFooter({super.key, required this.children});

  @override
  Widget build(BuildContext context) {
    if (children.isEmpty) {
      return const SizedBox.shrink();
    }

    final List<Widget> primaryButtons = [];
    final List<Widget> secondaryButtons = [];

    for (var w in children) {
      if (w is BmnButton) {
        final processedButton = BmnButton(
          key: w.key,
          variant: w.variant,
          size: w.size,
          icon: w.icon,
          iconSize: w.iconSize,
          text: w.text,
          processing: w.processing,
          onPressed: w.onPressed,
          disabled: w.disabled,
          width: double.infinity,
          child: w.child,
        );

        final isPrimary = w.variant == BmnButtonVariant.primary || w.variant == BmnButtonVariant.danger;
        if (isPrimary) {
          primaryButtons.add(processedButton);
        } else {
          secondaryButtons.add(processedButton);
        }
      } else {
        secondaryButtons.add(w);
      }
    }

    final processedChildren = [...primaryButtons, ...secondaryButtons];

    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: processedChildren.expand((w) => [w, const SizedBox(height: 8)]).toList()..removeLast(),
      ),
    );
  }
}
