import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:threezinstacart/theme/bmn_theme.dart';

enum BmnAvatarSize {
  xs,
  sm,
  defaultSize,
  lg,
}

enum BmnAvatarShape {
  circle,
  square,
}

class BmnAvatar extends StatelessWidget {
  final BmnAvatarSize size;
  final BmnAvatarShape shape;
  final bool bordered;
  final Widget child;

  const BmnAvatar({
    super.key,
    this.size = BmnAvatarSize.defaultSize,
    this.shape = BmnAvatarShape.circle,
    this.bordered = false,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    double sizeVal;
    double borderRadiusVal;

    switch (size) {
      case BmnAvatarSize.xs:
        sizeVal = 32;
        borderRadiusVal = 8;
        break;
      case BmnAvatarSize.sm:
        sizeVal = 48;
        borderRadiusVal = 12;
        break;
      case BmnAvatarSize.defaultSize:
        sizeVal = 64;
        borderRadiusVal = 16;
        break;
      case BmnAvatarSize.lg:
        sizeVal = 80;
        borderRadiusVal = 20;
        break;
    }

    final BoxBorder? innerBorder = bordered
        ? Border.all(color: BmnColors.brandGreen500, width: 2)
        : null;

    final double innerPadding = bordered ? 0.0 : 0.0;

    final BoxShape boxShape = shape == BmnAvatarShape.circle
        ? BoxShape.circle
        : BoxShape.rectangle;

    final BorderRadius? innerRadius = shape == BmnAvatarShape.circle
        ? null
        : BorderRadius.circular(borderRadiusVal);

    Widget avatarCore = Container(
      width: sizeVal,
      height: sizeVal,
      decoration: BoxDecoration(
        color: BmnColors.gray50,
        shape: boxShape,
        borderRadius: innerRadius,
        border: innerBorder,
      ),
      padding: EdgeInsets.all(innerPadding),
      clipBehavior: Clip.antiAlias,
      child: Center(
        child: child,
      ),
    );

    if (bordered) {
      // Add the outer brandGreen50 ring
      final double ringPadding = size == BmnAvatarSize.xs
          ? 2
          : size == BmnAvatarSize.sm
              ? 3
              : 4;
      return Container(
        padding: EdgeInsets.all(ringPadding),
        decoration: BoxDecoration(
          color: Colors.transparent,
          shape: boxShape,
          borderRadius: innerRadius != null
              ? BorderRadius.circular(borderRadiusVal + ringPadding)
              : null,
          border: Border.all(color: BmnColors.brandGreen50, width: ringPadding),
        ),
        child: avatarCore,
      );
    }

    return avatarCore;
  }
}

class BmnAvatarInitials extends StatelessWidget {
  final String initials;
  final Color? color;

  const BmnAvatarInitials({
    super.key,
    required this.initials,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    // Find text size based on parent avatar size if possible
    // Default to a medium size since font size is configured by the parent BmnAvatar text theme
    return Text(
      initials.substring(0, initials.length.clamp(0, 2)).toUpperCase(),
      style: TextStyle(
        color: color ?? BmnColors.gray800,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}

class BmnAvatarIcon extends StatelessWidget {
  final IconData icon;
  final Color color;
  final double? size;

  const BmnAvatarIcon({
    super.key,
    required this.icon,
    this.color = BmnColors.gray400,
    this.size,
  });

  @override
  Widget build(BuildContext context) {
    return Icon(
      icon,
      color: color,
      size: size ?? 24,
    );
  }
}

class BmnAvatarImage extends StatelessWidget {
  final String src;
  final String alt;

  const BmnAvatarImage({
    super.key,
    required this.src,
    this.alt = '',
  });

  @override
  Widget build(BuildContext context) {
    if (src.isEmpty) {
      return Container(
        color: BmnColors.gray100,
        child: const Icon(Icons.person, color: BmnColors.gray400),
      );
    }

    if (src.startsWith('data:image')) {
      try {
        final commaIndex = src.indexOf(',');
        final base64Str = commaIndex != -1 ? src.substring(commaIndex + 1) : src;
        final bytes = base64Decode(base64Str);
        return Image.memory(
          bytes,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => Container(
            color: BmnColors.gray100,
            child: const Icon(Icons.person, color: BmnColors.gray400),
          ),
        );
      } catch (_) {
        return Container(
          color: BmnColors.gray100,
          child: const Icon(Icons.person, color: BmnColors.gray400),
        );
      }
    }

    // Check if image is an asset or network image
    final bool isNetwork = src.startsWith('http') || src.startsWith('/');

    if (isNetwork) {
      final fullUrl = src;

      return CachedNetworkImage(
        imageUrl: fullUrl,
        fit: BoxFit.cover,
        placeholder: (context, url) => Container(
          color: BmnColors.gray100,
          child: Center(
            child: SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: BmnColors.brandGreen600,
              ),
            ),
          ),
        ),
        errorWidget: (context, url, error) => Container(
          color: BmnColors.gray100,
          child: const Icon(Icons.person, color: BmnColors.gray400),
        ),
      );
    }

    return Image.asset(
      src,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) => Container(
        color: BmnColors.gray100,
        child: const Icon(Icons.person, color: BmnColors.gray400),
      ),
    );
  }
}
