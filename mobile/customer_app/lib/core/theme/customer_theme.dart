import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

// ─────────────────────────────────────────────────────────────────────────────
// CUSTOMER APP — COASTAL FREIGHT CLARITY
// Design direction: Modern Coastal Logistics · Institutional · Reliable
// Source of truth: mobile/customer_app/ui/ux/design.md
// ─────────────────────────────────────────────────────────────────────────────

abstract class CustomerColors {
  CustomerColors._();

  // ── Primary ────────────────────────────────────────────────────────────────
  static const Color primary = Color(0xFF00183B);
  static const Color onPrimary = Color(0xFFFFFFFF);
  static const Color primaryContainer = Color(0xFF0F2D59); // Institutional deep royal navy
  static const Color onPrimaryContainer = Color(0xFF7C95C8);
  static const Color inversePrimary = Color(0xFFADC7FC);

  // ── Secondary ──────────────────────────────────────────────────────────────
  static const Color secondary = Color(0xFF006398); // Vibrant cerulean blue
  static const Color onSecondary = Color(0xFFFFFFFF);
  static const Color secondaryContainer = Color(0xFF5BB8FE);
  static const Color onSecondaryContainer = Color(0xFF00476E);

  // ── Tertiary ───────────────────────────────────────────────────────────────
  static const Color tertiary = Color(0xFF101A23);
  static const Color onTertiary = Color(0xFFFFFFFF);
  static const Color tertiaryContainer = Color(0xFF252F38);
  static const Color onTertiaryContainer = Color(0xFF8C97A2);

  // ── Background & Surfaces ──────────────────────────────────────────────────
  static const Color background = Color(0xFFF7F9FE); // Tinted slate off-white
  static const Color onBackground = Color(0xFF181C20);
  
  static const Color surface = Color(0xFFF7F9FE);
  static const Color onSurface = Color(0xFF181C20); // Slate charcoal
  static const Color onSurfaceVariant = Color(0xFF44474F);

  static const Color surfaceContainerLowest = Color(0xFFFFFFFF); // Pure crisp white
  static const Color surfaceContainerLow = Color(0xFFF1F4F9);
  static const Color surfaceContainer = Color(0xFFEBEEF3);
  static const Color surfaceContainerHigh = Color(0xFFE5E8ED);
  static const Color surfaceContainerHighest = Color(0xFFDFE3E8);
  static const Color surfaceBright = Color(0xFFF7F9FE);
  static const Color surfaceDim = Color(0xFFD7DADF);
  static const Color surfaceTint = Color(0xFF455E8D);

  // ── Borders ────────────────────────────────────────────────────────────────
  static const Color outline = Color(0xFF747780);
  static const Color outlineVariant = Color(0xFFC4C6D0);

  // ── Inverse ────────────────────────────────────────────────────────────────
  static const Color inverseSurface = Color(0xFF2D3135);
  static const Color inverseOnSurface = Color(0xFFEEF1F6);

  // ── Semantic ───────────────────────────────────────────────────────────────
  static const Color error = Color(0xFFBA1A1A);
  static const Color onError = Color(0xFFFFFFFF);
  static const Color errorContainer = Color(0xFFFFDAD6);
  static const Color onErrorContainer = Color(0xFF93000A);
  
  // Custom Semantic (Aligned to Coastal Freight)
  static const Color success = Color(0xFF10B981); 
  static const Color warning = Color(0xFFF59E0B);
  static const Color info = Color(0xFF3B82F6);
  
  static Color dividerBase = const Color(0xFFD1D9E6);
}

// ─────────────────────────────────────────────────────────────────────────────
// TYPOGRAPHY — Epilogue (headings) + Inter (body)
// Gujarati glyphs fall through to system font stack (Noto Sans Gujarati).
// ─────────────────────────────────────────────────────────────────────────────
abstract class CustomerTextStyles {
  CustomerTextStyles._();

  // Epilogue — structural headings
  static TextStyle headlineXl = GoogleFonts.epilogue(
    fontSize: 40, fontWeight: FontWeight.w700, height: 48 / 40,
    color: CustomerColors.onSurface,
  );
  static TextStyle headlineLg = GoogleFonts.epilogue(
    fontSize: 32, fontWeight: FontWeight.w600, height: 40 / 32,
    color: CustomerColors.onSurface,
  );
  static TextStyle headlineMd = GoogleFonts.epilogue(
    fontSize: 24, fontWeight: FontWeight.w600, height: 32 / 24,
    color: CustomerColors.onSurface,
  );
  static TextStyle headlineSm = GoogleFonts.epilogue(
    fontSize: 18, fontWeight: FontWeight.w600, height: 24 / 18,
    color: CustomerColors.onSurface,
  );

  // Inter — body & labels
  static TextStyle titleLg = GoogleFonts.inter(
    fontSize: 18, fontWeight: FontWeight.w700, height: 28 / 18,
    color: CustomerColors.onSurface,
  );
  static TextStyle titleMd = GoogleFonts.inter(
    fontSize: 16, fontWeight: FontWeight.w600, height: 24 / 16,
    color: CustomerColors.onSurface,
  );
  static TextStyle bodyLg = GoogleFonts.inter(
    fontSize: 18, fontWeight: FontWeight.w400, height: 28 / 18,
    color: CustomerColors.onSurface,
  );
  static TextStyle bodyMd = GoogleFonts.inter(
    fontSize: 15, fontWeight: FontWeight.w400, height: 22 / 15,
    color: CustomerColors.onSurface,
  );
  static TextStyle bodySm = GoogleFonts.inter(
    fontSize: 13, fontWeight: FontWeight.w400, height: 18 / 13,
    color: CustomerColors.onSurfaceVariant,
  );
  static TextStyle labelLg = GoogleFonts.inter(
    fontSize: 14, fontWeight: FontWeight.w600, height: 20 / 14,
    color: CustomerColors.onSurface,
  );
  static TextStyle labelMd = GoogleFonts.inter(
    fontSize: 12, fontWeight: FontWeight.w600, height: 16 / 12,
    color: CustomerColors.onSurface,
  );
  static TextStyle labelSm = GoogleFonts.inter(
    fontSize: 11, fontWeight: FontWeight.w500, height: 14 / 11,
    color: CustomerColors.onSurfaceVariant,
  );
}

// ─────────────────────────────────────────────────────────────────────────────
// CUSTOMER THEME
// ─────────────────────────────────────────────────────────────────────────────
class CustomerTheme {
  CustomerTheme._();

  static ThemeData get theme {
    final colorScheme = const ColorScheme(
      brightness: Brightness.light,
      primary: CustomerColors.primary,
      onPrimary: CustomerColors.onPrimary,
      primaryContainer: CustomerColors.primaryContainer,
      onPrimaryContainer: CustomerColors.onPrimaryContainer,
      secondary: CustomerColors.secondary,
      onSecondary: CustomerColors.onSecondary,
      secondaryContainer: CustomerColors.secondaryContainer,
      onSecondaryContainer: CustomerColors.onSecondaryContainer,
      tertiary: CustomerColors.tertiary,
      onTertiary: CustomerColors.onTertiary,
      tertiaryContainer: CustomerColors.tertiaryContainer,
      onTertiaryContainer: CustomerColors.onTertiaryContainer,
      error: CustomerColors.error,
      onError: CustomerColors.onError,
      errorContainer: CustomerColors.errorContainer,
      onErrorContainer: CustomerColors.onErrorContainer,
      surface: CustomerColors.surface,
      onSurface: CustomerColors.onSurface,
      surfaceContainerLowest: CustomerColors.surfaceContainerLowest,
      surfaceContainerLow: CustomerColors.surfaceContainerLow,
      surfaceContainer: CustomerColors.surfaceContainer,
      surfaceContainerHigh: CustomerColors.surfaceContainerHigh,
      surfaceContainerHighest: CustomerColors.surfaceContainerHighest,
      onSurfaceVariant: CustomerColors.onSurfaceVariant,
      outline: CustomerColors.outline,
      outlineVariant: CustomerColors.outlineVariant,
      inverseSurface: CustomerColors.inverseSurface,
      onInverseSurface: CustomerColors.inverseOnSurface,
      inversePrimary: CustomerColors.inversePrimary,
    );

    final baseTextTheme = GoogleFonts.interTextTheme();

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: CustomerColors.background,

      // ── System UI ─────────────────────────────────────────────────────────
      appBarTheme: AppBarTheme(
        backgroundColor: CustomerColors.background,
        foregroundColor: CustomerColors.onSurface,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        titleTextStyle: CustomerTextStyles.headlineSm,
        iconTheme: const IconThemeData(color: CustomerColors.onSurface, size: 24),
      ),

      // ── Typography ────────────────────────────────────────────────────────
      textTheme: baseTextTheme.copyWith(
        displayLarge: CustomerTextStyles.headlineXl,
        displayMedium: CustomerTextStyles.headlineLg,
        displaySmall: CustomerTextStyles.headlineMd,
        headlineLarge: CustomerTextStyles.headlineLg,
        headlineMedium: CustomerTextStyles.headlineMd,
        headlineSmall: CustomerTextStyles.headlineSm,
        titleLarge: CustomerTextStyles.titleLg,
        titleMedium: CustomerTextStyles.titleMd,
        bodyLarge: CustomerTextStyles.bodyLg,
        bodyMedium: CustomerTextStyles.bodyMd,
        bodySmall: CustomerTextStyles.bodySm,
        labelLarge: CustomerTextStyles.labelLg,
        labelMedium: CustomerTextStyles.labelMd,
        labelSmall: CustomerTextStyles.labelSm,
      ),

      // ── Buttons ───────────────────────────────────────────────────────────
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: CustomerColors.secondary, // Cerulean
          foregroundColor: CustomerColors.onSecondary,
          minimumSize: const Size(double.infinity, 48),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          elevation: 0,
          textStyle: CustomerTextStyles.labelLg,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: CustomerColors.onSurface,
          minimumSize: const Size(double.infinity, 48),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          side: const BorderSide(color: Color(0xFFD1D9E6), width: 1.0),
          textStyle: CustomerTextStyles.labelLg,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: CustomerColors.secondary,
          textStyle: CustomerTextStyles.labelLg,
        ),
      ),

      // ── Input Fields ──────────────────────────────────────────────────────
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: CustomerColors.surfaceContainerLowest,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        constraints: const BoxConstraints(minHeight: 48),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFFD1D9E6), width: 1.5),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFFD1D9E6), width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: CustomerColors.secondary, width: 2), // Cerulean
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: CustomerColors.error, width: 1.5),
        ),
        hintStyle: CustomerTextStyles.bodyMd.copyWith(color: const Color(0xFF64748B)),
        labelStyle: CustomerTextStyles.bodyMd.copyWith(color: CustomerColors.onSurfaceVariant),
      ),

      // ── Cards ─────────────────────────────────────────────────────────────
      cardTheme: CardThemeData(
        color: CustomerColors.surfaceContainerLowest,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: const BorderSide(color: Color(0xFFD1D9E6), width: 1.0),
        ),
        margin: EdgeInsets.zero,
      ),

      // ── Chips ─────────────────────────────────────────────────────────────
      chipTheme: ChipThemeData(
        backgroundColor: CustomerColors.surfaceContainerLowest,
        selectedColor: CustomerColors.primaryContainer, // Navy
        labelStyle: CustomerTextStyles.labelMd,
        side: const BorderSide(color: Color(0xFFD1D9E6), width: 1.0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      ),

      // ── Navigation ────────────────────────────────────────────────────────
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: CustomerColors.surfaceContainerLowest,
        indicatorColor: CustomerColors.surfaceContainerLow,
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const IconThemeData(color: CustomerColors.primaryContainer, size: 24);
          }
          return const IconThemeData(color: CustomerColors.onSurfaceVariant, size: 24);
        }),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          final base = GoogleFonts.epilogue(fontSize: 12, fontWeight: FontWeight.w600);
          if (states.contains(WidgetState.selected)) {
            return base.copyWith(color: CustomerColors.primaryContainer);
          }
          return base.copyWith(color: CustomerColors.onSurfaceVariant);
        }),
        elevation: 0,
        height: 68,
      ),

      // ── Snackbar ──────────────────────────────────────────────────────────
      snackBarTheme: SnackBarThemeData(
        backgroundColor: CustomerColors.primaryContainer.withValues(alpha: 0.95), // 95% opacity deep navy
        contentTextStyle: CustomerTextStyles.bodyMd.copyWith(color: CustomerColors.onPrimary),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        behavior: SnackBarBehavior.floating,
      ),

      // ── Dialog ────────────────────────────────────────────────────────────
      dialogTheme: DialogThemeData(
        backgroundColor: CustomerColors.surfaceContainerLowest,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        titleTextStyle: CustomerTextStyles.headlineMd,
        contentTextStyle: CustomerTextStyles.bodyMd,
      ),

      // ── Divider ───────────────────────────────────────────────────────────
      dividerTheme: const DividerThemeData(
        color: Color(0xFFD1D9E6),
        thickness: 1,
        space: 1,
      ),

      // ── Progress Indicator ────────────────────────────────────────────────
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: CustomerColors.secondary, // Cerulean
      ),
    );
  }
}
