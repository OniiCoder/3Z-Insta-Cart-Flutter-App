import 'package:flutter/material.dart';
import '../../theme/bmn_theme.dart';

class AppColors {
  // Brand Palette mapped to BmnColors
  static Color get primary => BmnColors.brand600;
  static Color get primaryDark => BmnColors.brand700;
  static Color get primaryLight => BmnColors.brand100;
  static Color get primarySurface => BmnColors.brand50;

  static const Color secondary = BmnColors.orange500;
  static const Color secondaryLight = BmnColors.orange100;

  static const Color background = BmnColors.gray50;
  static const Color cardBackground = Colors.white;
  static const Color textPrimary = BmnColors.gray900;
  static const Color textSecondary = BmnColors.gray500;
  static const Color textMuted = BmnColors.gray400;
  static const Color border = BmnColors.gray200;

  static const Color success = BmnColors.green500;
  static const Color warning = BmnColors.orange500;
  static const Color error = BmnColors.red500;
  static const Color info = BmnColors.blue500;
}
