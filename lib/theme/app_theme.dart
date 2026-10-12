/// ════════════════════════════════════════════════════════════════
///  RAMCOSPLY — Design System "Neo-Tokyo Cosplay Studio"
/// ════════════════════════════════════════════════════════════════
/// Filosofi: kontras tinggi, aksen vermillion (bukan ungu generic),
/// sudut tegas, dan tipografi berkarakter. Setiap elemen punya
/// tujuan visual — tanpa glassmorphism atau gradient berlebihan.
library;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


class AppColors {
  AppColors._();

  // ── Background layers (near-black netral ber-tint dingin) ──
  static const Color scaffoldDark = Color(0xFF08080D);
  static const Color surfaceDark = Color(0xFF0F0F17);
  static const Color cardDark = Color(0xFF16161F);
  static const Color cardDarkAlt = Color(0xFF1E1E2A);
  static const Color bgElevated = Color(0xFF25252F);

  // ── Signature accent — Vermillion (energi shonen / matahari terbit) ──
  static const Color primary = Color(0xFFFF3B5C);
  static const Color primaryLight = Color(0xFFFF6B82);
  static const Color primaryDark = Color(0xFFD62246);
  static const Color primarySoft = Color(0x29FF3B5C); // tint transparan

  // ── Secondary accent — Electric cyan (cyber / chakra) ──
  static const Color accent = Color(0xFF2DE2E6);
  static const Color accentDark = Color(0xFF16B8BC);
  static const Color accentSoft = Color(0x292DE2E6);

  // ── Premium accent — Gold (rating / membership) ──
  static const Color gold = Color(0xFFFFC93C);
  static const Color goldDark = Color(0xFFE0A800);

  // ── Status colours ──
  static const Color success = Color(0xFF2DD4A7);
  static const Color warning = Color(0xFFFFB020);
  static const Color error = Color(0xFFFF3B5C);
  static const Color info = Color(0xFF38BDF8);

  // ── Text ──
  static const Color textPrimary = Color(0xFFF5F5F8);
  static const Color textSecondary = Color(0xFF9CA0B4);
  static const Color textMuted = Color(0xFF5C6070);

  // ── Misc ──
  static const Color divider = Color(0xFF242433);
  static const Color dividerLight = Color(0xFF32323F);
  static const Color shimmer = Color(0xFF20202C);
  static const Color overlay = Color(0xB3000000); // 70% hitam
}

/// Radius tokens untuk menjaga konsistensi sudut di seluruh app.
class AppRadii {
  AppRadii._();
  static const double sm = 10;
  static const double md = 14;
  static const double lg = 18;
  static const double xl = 24;
}

class AppTheme {
  AppTheme._();

  // ── Font helpers ──────────────────────────────────────────────
  /// Body / teks umum — geometris, modern, lebih berkarakter dari Poppins.
  static TextStyle body(
    double size, {
    FontWeight weight = FontWeight.w400,
    Color color = AppColors.textPrimary,
    double height = 1.4,
    double? letterSpacing,
  }) =>
      GoogleFonts.outfit(
        fontSize: size,
        fontWeight: weight,
        color: color,
        height: height,
        letterSpacing: letterSpacing,
      );

  /// Heading / judul — angular & techy (nuansa anime HUD).
  static TextStyle heading(
    double size, {
    FontWeight weight = FontWeight.w700,
    Color color = AppColors.textPrimary,
    double? letterSpacing,
  }) =>
      GoogleFonts.rajdhani(
        fontSize: size,
        fontWeight: weight,
        color: color,
        letterSpacing: letterSpacing,
      );

  /// Display / brand — poster condensed yang kuat.
  static TextStyle display(
    double size, {
    Color color = AppColors.textPrimary,
    double letterSpacing = 1,
  }) =>
      GoogleFonts.bebasNeue(fontSize: size, color: color, letterSpacing: letterSpacing);

  // ── Signature gradient (dipakai hemat, hanya untuk CTA utama) ──
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [AppColors.primaryDark, AppColors.primary, AppColors.primaryLight],
  );

  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.scaffoldDark,
      primaryColor: AppColors.primary,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.primary,
        secondary: AppColors.accent,
        surface: AppColors.surfaceDark,
        error: AppColors.error,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: AppColors.textPrimary,
        onError: Colors.white,
      ),

      // ── AppBar ──
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        titleTextStyle: heading(20, weight: FontWeight.w700, letterSpacing: 1),
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
      ),

      // ── Card ──
      cardTheme: CardThemeData(
        color: AppColors.cardDark,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadii.lg),
          side: const BorderSide(color: AppColors.divider),
        ),
        margin: EdgeInsets.zero,
      ),

      // ── Input ──
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.bgElevated,
        contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        hintStyle: body(14, color: AppColors.textMuted),
        labelStyle: body(14, color: AppColors.textSecondary),
        prefixIconColor: AppColors.textMuted,
        suffixIconColor: AppColors.textMuted,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadii.md),
          borderSide: const BorderSide(color: AppColors.dividerLight),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadii.md),
          borderSide: const BorderSide(color: AppColors.dividerLight),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadii.md),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadii.md),
          borderSide: const BorderSide(color: AppColors.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadii.md),
          borderSide: const BorderSide(color: AppColors.error, width: 1.5),
        ),
      ),

      // ── Elevated Button ──
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadii.md),
          ),
          textStyle: body(15, weight: FontWeight.w600, letterSpacing: 0.3),
        ),
      ),

      // ── Text Button ──
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primary,
          textStyle: body(14, weight: FontWeight.w600),
        ),
      ),

      // ── Outlined Button ──
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.textPrimary,
          side: const BorderSide(color: AppColors.dividerLight),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadii.md),
          ),
          textStyle: body(15, weight: FontWeight.w600),
        ),
      ),

      // ── Text ──
      textTheme: TextTheme(
        headlineLarge: heading(28, letterSpacing: 0.5),
        headlineMedium: heading(24, letterSpacing: 0.5),
        headlineSmall: heading(20, weight: FontWeight.w700),
        titleLarge: heading(18, weight: FontWeight.w700),
        titleMedium: body(15, weight: FontWeight.w600),
        titleSmall: body(13, weight: FontWeight.w600),
        bodyLarge: body(15),
        bodyMedium: body(13, color: AppColors.textSecondary),
        bodySmall: body(12, color: AppColors.textMuted),
        labelLarge: body(14, weight: FontWeight.w600),
      ),

      // ── Divider ──
      dividerTheme: const DividerThemeData(
        color: AppColors.divider,
        thickness: 1,
        space: 1,
      ),

      // ── Dialog ──
      dialogTheme: DialogThemeData(
        backgroundColor: AppColors.surfaceDark,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadii.xl),
          side: const BorderSide(color: AppColors.dividerLight),
        ),
        titleTextStyle: heading(20, weight: FontWeight.w700),
        contentTextStyle: body(14, color: AppColors.textSecondary),
      ),

      // ── Snackbar ──
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.cardDarkAlt,
        contentTextStyle: body(13, color: AppColors.textPrimary),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadii.sm),
          side: const BorderSide(color: AppColors.dividerLight),
        ),
        behavior: SnackBarBehavior.floating,
        elevation: 0,
      ),

      // ── Bottom Nav ──
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Colors.transparent,
        elevation: 0,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textMuted,
        type: BottomNavigationBarType.fixed,
        showSelectedLabels: true,
        showUnselectedLabels: true,
      ),

      // ── Switch ──
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return AppColors.success;
          return AppColors.textMuted;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.success.withOpacity(0.3);
          }
          return AppColors.dividerLight;
        }),
        trackOutlineColor: WidgetStateProperty.all(Colors.transparent),
      ),

      // ── FloatingActionButton ──
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 4,
        focusElevation: 6,
        shape: StadiumBorder(),
      ),

      // ── Checkbox / Radio ──
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return AppColors.primary;
          return Colors.transparent;
        }),
        checkColor: WidgetStateProperty.all(Colors.white),
        side: const BorderSide(color: AppColors.textMuted, width: 1.5),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      ),
      radioTheme: RadioThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return AppColors.primary;
          return AppColors.textMuted;
        }),
      ),

      // ── Progress indicator ──
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: AppColors.primary,
        linearTrackColor: AppColors.divider,
      ),

      // ── Tooltip ──
      tooltipTheme: TooltipThemeData(
        decoration: BoxDecoration(
          color: AppColors.cardDarkAlt,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.dividerLight),
        ),
        textStyle: body(12, color: AppColors.textPrimary),
      ),
    );
  }
}
