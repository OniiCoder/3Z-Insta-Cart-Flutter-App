import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

enum AppThemeVariant { green, purple }

class AppConfig {
  static AppThemeVariant activeTheme = AppThemeVariant.green;
}

class BmnColors {
  // Version 2 Purple Scale (Royal Violet)
  static const Color purple50 = Color(0xFFF5F3FF);
  static const Color purple100 = Color(0xFFEDE9FE);
  static const Color purple200 = Color(0xFFDDD6FE);
  static const Color purple300 = Color(0xFFC4B5FD);
  static const Color purple400 = Color(0xFFA78BFA);
  static const Color purple500 = Color(0xFF8B5CF6);
  static const Color purple600 = Color(0xFF7C3AED);
  static const Color purple700 = Color(0xFF6D28D9);
  static const Color purple800 = Color(0xFF5B21B6);
  static const Color purple900 = Color(0xFF4C1D95);

  // Version 1 Classic Green Scale (Emerald)
  static const Color green50 = Color(0xFFE3FAF4);
  static const Color green100 = Color(0xFFC8FFF1);
  static const Color green200 = Color(0xFF90FFE2);
  static const Color green300 = Color(0xFF51F7D3);
  static const Color green400 = Color(0xFF1DE4BF);
  static const Color green500 = Color(0xFF05C7A6);
  static const Color green600 = Color(0xFF00806C);
  static const Color green700 = Color(0xFF05806E);
  static const Color green800 = Color(0xFF0A4D43);
  static const Color green900 = Color(0xFF083530);

  // Active Brand Palette (Resolves automatically based on AppConfig.activeTheme)
  static Color get brand50 => AppConfig.activeTheme == AppThemeVariant.purple ? purple50 : green50;
  static Color get brand100 => AppConfig.activeTheme == AppThemeVariant.purple ? purple100 : green100;
  static Color get brand200 => AppConfig.activeTheme == AppThemeVariant.purple ? purple200 : green200;
  static Color get brand300 => AppConfig.activeTheme == AppThemeVariant.purple ? purple300 : green300;
  static Color get brand400 => AppConfig.activeTheme == AppThemeVariant.purple ? purple400 : green400;
  static Color get brand500 => AppConfig.activeTheme == AppThemeVariant.purple ? purple500 : green500;
  static Color get brand600 => AppConfig.activeTheme == AppThemeVariant.purple ? purple600 : green600;
  static Color get brand700 => AppConfig.activeTheme == AppThemeVariant.purple ? purple700 : green700;
  static Color get brand800 => AppConfig.activeTheme == AppThemeVariant.purple ? purple800 : green800;
  static Color get brand900 => AppConfig.activeTheme == AppThemeVariant.purple ? purple900 : green900;

  // Primary Action Color Aliases
  static Color get primary => brand600;
  static Color get primaryDark => brand700;
  static Color get primaryLight => brand50;
  static Color get primaryBorder => brand200;

  // Backwards-Compatible Brand Green Aliases (Route to Active Brand Palette)
  static Color get brandGreen50 => brand50;
  static Color get brandGreen100 => brand100;
  static Color get brandGreen200 => brand200;
  static Color get brandGreen300 => brand300;
  static Color get brandGreen400 => brand400;
  static Color get brandGreen500 => brand500;
  static Color get brandGreen600 => brand600;
  static Color get brandGreen700 => brand700;
  static Color get brandGreen800 => brand800;
  static Color get brandGreen900 => brand900;

  // Gray Scale
  static const Color gray50 = Color(0xFFF8FAFC);
  static const Color gray100 = Color(0xFFF1F5F9);
  static const Color gray200 = Color(0xFFE2E8F0);
  static const Color gray300 = Color(0xFFCBD5E1);
  static const Color gray400 = Color(0xFF94A3B8);
  static const Color gray500 = Color(0xFF64748B);
  static const Color gray600 = Color(0xFF475569);
  static const Color gray700 = Color(0xFF334155);
  static const Color gray800 = Color(0xFF1E293B);
  static const Color gray900 = Color(0xFF0F172A);

  // Red Scale
  static const Color red50 = Color(0xFFFFF1F2);
  static const Color red100 = Color(0xFFFFE4E6);
  static const Color red200 = Color(0xFFFECDD3);
  static const Color red300 = Color(0xFFFDA4AF);
  static const Color red400 = Color(0xFFFB7185);
  static const Color red500 = Color(0xFFF43F5E);
  static const Color red600 = Color(0xFFE11D48);
  static const Color red700 = Color(0xFFBE123C);
  static const Color red800 = Color(0xFF9F1239);
  static const Color red900 = Color(0xFF881337);

  // Blue Scale
  static const Color blue50 = Color(0xFFEFF6FF);
  static const Color blue100 = Color(0xFFDBEAFE);
  static const Color blue200 = Color(0xFFBFDBFE);
  static const Color blue300 = Color(0xFF93C5FD);
  static const Color blue400 = Color(0xFF60A5FA);
  static const Color blue500 = Color(0xFF3B82F6);
  static const Color blue600 = Color(0xFF2563EB);
  static const Color blue700 = Color(0xFF1D4ED8);
  static const Color blue800 = Color(0xFF1E40AF);
  static const Color blue900 = Color(0xFF1E3A8A);

  // Orange / Amber Scale
  static const Color orange50 = Color(0xFFFFFBEB);
  static const Color orange100 = Color(0xFFFEF3C7);
  static const Color orange200 = Color(0xFFFDE68A);
  static const Color orange300 = Color(0xFFFCD34D);
  static const Color orange400 = Color(0xFFFBBF24);
  static const Color orange500 = Color(0xFFF59E0B);
  static const Color orange600 = Color(0xFFD97706);
  static const Color orange700 = Color(0xFFB45309);
  static const Color orange800 = Color(0xFF92400E);
  static const Color orange900 = Color(0xFF78350F);
}

class BmnFonts {
  static const String body = 'Matter';
  static const String display = 'Fraunces';
  static const String displaySoft = 'FrauncesSoft';
  static const String displaySuperSoft = 'FrauncesSuperSoft';
}

class BmnTheme {
  static ThemeData get lightTheme {
    final primary = BmnColors.primary;
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: const Color(0xFFF8FAFC),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        titleTextStyle: TextStyle(
          fontWeight: FontWeight.w800,
          fontSize: 20,
          color: BmnColors.gray900,
          letterSpacing: -0.3,
        ),
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.light,
        ),
      ),
      colorScheme: ColorScheme.fromSeed(
        seedColor: primary,
        brightness: Brightness.light,
        primary: primary,
        surface: Colors.white,
      ),
      cardTheme: CardThemeData(
        color: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: BmnColors.gray200, width: 1),
        ),
      ),
      textTheme: const TextTheme(
        bodyMedium: TextStyle(color: BmnColors.gray800, fontSize: 14, fontWeight: FontWeight.w500),
      ),
    );
  }
}
