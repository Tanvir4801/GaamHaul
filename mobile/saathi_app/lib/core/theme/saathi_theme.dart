import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

// ─────────────────────────────────────────────────────────────────────────────
// SAATHI APP — RURAL WORKHORSE COCKPIT
// Design direction: Strong · Practical · Operational · High-contrast · Outdoor
// Source of truth: mobile/saathi_app/ui/ux/design.md
// ─────────────────────────────────────────────────────────────────────────────

abstract class SaathiColors {
  SaathiColors._();

  // ── Base Surfaces ────────────────────────────────────────────────────────
  static const Color background = Color(0xFF111413);        // Graphite base
  static const Color surface = Color(0xFF111413);
  static const Color surfaceContainerLowest = Color(0xFF0C0F0E); // Inset/recess
  static const Color surfaceContainerLow = Color(0xFF191C1B);
  static const Color surfaceContainer = Color(0xFF1D201F);   // Cockpit Deck
  static const Color surfaceContainerHigh = Color(0xFF282B29); // Raised controls
  static const Color surfaceContainerHighest = Color(0xFF323534);
  static const Color surfaceBright = Color(0xFF373A39);
  static const Color surfaceDim = Color(0xFF111413);

  // ── Primary: Industrial Amber ─────────────────────────────────────────────
  static const Color primary = Color(0xFFFFC66F);           // Amber CTA
  static const Color onPrimary = Color(0xFF442B00);
  static const Color primaryContainer = Color(0xFFE8A83E);  // Darker amber
  static const Color onPrimaryContainer = Color(0xFF603F00);
  static const Color inversePrimary = Color(0xFF805600);

  // ── Secondary: Signal Green ───────────────────────────────────────────────
  static const Color secondary = Color(0xFF53DE9D);          // On Duty
  static const Color onSecondary = Color(0xFF003822);
  static const Color secondaryContainer = Color(0xFF04B175);
  static const Color onSecondaryContainer = Color(0xFF003B24);

  // ── Tertiary ─────────────────────────────────────────────────────────────
  static const Color tertiary = Color(0xFFFEC669);
  static const Color onTertiary = Color(0xFF432C00);
  static const Color tertiaryContainer = Color(0xFFDFAB51);
  static const Color onTertiaryContainer = Color(0xFF5E4000);

  // ── Text / Content ────────────────────────────────────────────────────────
  static const Color onSurface = Color(0xFFE1E3E1);          // Ivory Enamel
  static const Color onSurfaceVariant = Color(0xFFD5C4B0);   // Weathered bone
  static const Color onBackground = Color(0xFFE1E3E1);

  // ── Borders ───────────────────────────────────────────────────────────────
  static const Color outline = Color(0xFF9D8E7C);
  static const Color outlineVariant = Color(0xFF504536);
  static const Color structuralStroke = Color(0xFF333A36);   // Main structural border

  // ── Inverse ───────────────────────────────────────────────────────────────
  static const Color inverseSurface = Color(0xFFE1E3E1);
  static const Color inverseOnSurface = Color(0xFF2E3130);

  // ── Error ─────────────────────────────────────────────────────────────────
  static const Color error = Color(0xFFFFB4AB);
  static const Color onError = Color(0xFF690005);
  static const Color errorContainer = Color(0xFF93000A);
  static const Color onErrorContainer = Color(0xFFFFDAD6);

  // ── Semantic ─────────────────────────────────────────────────────────────
  /// Warning / Danger (cancellation, breakdown)
  static const Color danger = Color(0xFFD95C4A);
  /// Muted gold — secondary accents, badges
  static const Color muted = Color(0xFFB98932);
  /// On-duty indicator dot
  static const Color onDutyGreen = Color(0xFF53DE9D);
  /// Active haul banner
  static const Color activeHaulGreen = Color(0xFF04B175);
  /// Active haul border
  static const Color activeHaulBorder = Color(0xFF53DE9D);
}

// ─────────────────────────────────────────────────────────────────────────────
// TYPOGRAPHY — Epilogue (all headings, labels, numbers) + Inter (body, data)
//
// Gujarati rendering note:
// Same as Customer — Epilogue and Inter are Latin-only. Gujarati falls
// through to system font (Noto Sans Gujarati on Android). This is correct
// behavior. The Saathi app has less Gujarati content than Customer, mostly
// in labels and status text.
// ─────────────────────────────────────────────────────────────────────────────
abstract class SaathiTextStyles {
  SaathiTextStyles._();

  // Epilogue — structural / operational headings
  static TextStyle headlineXl = GoogleFonts.epilogue(
    fontSize: 32, fontWeight: FontWeight.w800,
    height: 40 / 32, letterSpacing: -0.02 * 32,
    color: SaathiColors.onSurface,
  );
  static TextStyle headlineLg = GoogleFonts.epilogue(
    fontSize: 26, fontWeight: FontWeight.w700,
    height: 34 / 26, letterSpacing: -0.01 * 26,
    color: SaathiColors.onSurface,
  );
  static TextStyle headlineMd = GoogleFonts.epilogue(
    fontSize: 20, fontWeight: FontWeight.w700,
    height: 28 / 20,
    color: SaathiColors.onSurface,
  );
  static TextStyle labelLg = GoogleFonts.epilogue(
    fontSize: 16, fontWeight: FontWeight.w700,
    height: 22 / 16, letterSpacing: 0.04 * 16,
    color: SaathiColors.onSurface,
  );
  static TextStyle labelMd = GoogleFonts.epilogue(
    fontSize: 13, fontWeight: FontWeight.w700,
    height: 18 / 13, letterSpacing: 0.06 * 13,
    color: SaathiColors.onSurface,
  );
  static TextStyle labelSm = GoogleFonts.epilogue(
    fontSize: 11, fontWeight: FontWeight.w800,
    height: 16 / 11, letterSpacing: 0.08 * 11,
    color: SaathiColors.onSurfaceVariant,
  );

  // Inter — body, data tables, location text
  static TextStyle bodyLg = GoogleFonts.inter(
    fontSize: 18, fontWeight: FontWeight.w600,
    height: 26 / 18,
    color: SaathiColors.onSurface,
  );
  static TextStyle bodyMd = GoogleFonts.inter(
    fontSize: 16, fontWeight: FontWeight.w500,
    height: 24 / 16,
    color: SaathiColors.onSurface,
  );
  static TextStyle bodySm = GoogleFonts.inter(
    fontSize: 14, fontWeight: FontWeight.w500,
    height: 20 / 14,
    color: SaathiColors.onSurfaceVariant,
  );
}

// ─────────────────────────────────────────────────────────────────────────────
// SAATHI THEME
// ─────────────────────────────────────────────────────────────────────────────
class SaathiTheme {
  SaathiTheme._();

  static ThemeData get theme {
    final colorScheme = const ColorScheme(
      brightness: Brightness.dark,
      primary: SaathiColors.primary,
      onPrimary: SaathiColors.onPrimary,
      primaryContainer: SaathiColors.primaryContainer,
      onPrimaryContainer: SaathiColors.onPrimaryContainer,
      secondary: SaathiColors.secondary,
      onSecondary: SaathiColors.onSecondary,
      secondaryContainer: SaathiColors.secondaryContainer,
      onSecondaryContainer: SaathiColors.onSecondaryContainer,
      tertiary: SaathiColors.tertiary,
      onTertiary: SaathiColors.onTertiary,
      tertiaryContainer: SaathiColors.tertiaryContainer,
      onTertiaryContainer: SaathiColors.onTertiaryContainer,
      error: SaathiColors.error,
      onError: SaathiColors.onError,
      errorContainer: SaathiColors.errorContainer,
      onErrorContainer: SaathiColors.onErrorContainer,
      surface: SaathiColors.surface,
      onSurface: SaathiColors.onSurface,
      surfaceContainerLowest: SaathiColors.surfaceContainerLowest,
      surfaceContainerLow: SaathiColors.surfaceContainerLow,
      surfaceContainer: SaathiColors.surfaceContainer,
      surfaceContainerHigh: SaathiColors.surfaceContainerHigh,
      surfaceContainerHighest: SaathiColors.surfaceContainerHighest,
      onSurfaceVariant: SaathiColors.onSurfaceVariant,
      outline: SaathiColors.outline,
      outlineVariant: SaathiColors.outlineVariant,
      inverseSurface: SaathiColors.inverseSurface,
      onInverseSurface: SaathiColors.inverseOnSurface,
      inversePrimary: SaathiColors.inversePrimary,
    );

    final baseTextTheme = GoogleFonts.interTextTheme(ThemeData.dark().textTheme);

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: SaathiColors.background,

      // ── System UI ─────────────────────────────────────────────────────────
      appBarTheme: AppBarTheme(
        backgroundColor: SaathiColors.background,
        foregroundColor: SaathiColors.onSurface,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        systemOverlayStyle: SystemUiOverlayStyle.light,
        titleTextStyle: GoogleFonts.epilogue(
          fontSize: 20, fontWeight: FontWeight.w700,
          color: SaathiColors.onSurface,
        ),
        iconTheme: const IconThemeData(color: SaathiColors.onSurface, size: 24),
      ),

      // ── Typography ────────────────────────────────────────────────────────
      textTheme: baseTextTheme.copyWith(
        displayLarge: SaathiTextStyles.headlineXl,
        displayMedium: SaathiTextStyles.headlineLg,
        displaySmall: SaathiTextStyles.headlineMd,
        headlineLarge: SaathiTextStyles.headlineLg,
        headlineMedium: SaathiTextStyles.headlineMd,
        headlineSmall: SaathiTextStyles.headlineMd,
        titleLarge: SaathiTextStyles.labelLg,
        titleMedium: SaathiTextStyles.labelMd,
        bodyLarge: SaathiTextStyles.bodyLg,
        bodyMedium: SaathiTextStyles.bodyMd,
        bodySmall: SaathiTextStyles.bodySm,
        labelLarge: SaathiTextStyles.labelLg,
        labelMedium: SaathiTextStyles.labelMd,
        labelSmall: SaathiTextStyles.labelSm,
      ),

      // ── Buttons ───────────────────────────────────────────────────────────
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: SaathiColors.primaryContainer, // Industrial amber
          foregroundColor: SaathiColors.onPrimary,
          minimumSize: const Size(double.infinity, 56),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
          elevation: 0,
          textStyle: GoogleFonts.epilogue(fontSize: 16, fontWeight: FontWeight.w700, letterSpacing: 0.04 * 16),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: SaathiColors.onSurface,
          minimumSize: const Size(double.infinity, 52),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
          side: const BorderSide(color: SaathiColors.structuralStroke, width: 1.5),
          textStyle: GoogleFonts.epilogue(fontSize: 14, fontWeight: FontWeight.w700, letterSpacing: 0.04 * 14),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: SaathiColors.primary,
          textStyle: GoogleFonts.epilogue(fontSize: 14, fontWeight: FontWeight.w700),
        ),
      ),

      // ── Input Fields ──────────────────────────────────────────────────────
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: SaathiColors.surfaceContainerLowest, // Sunken tier
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        constraints: const BoxConstraints(minHeight: 56),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: const BorderSide(color: SaathiColors.structuralStroke, width: 2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: const BorderSide(color: SaathiColors.structuralStroke, width: 2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: const BorderSide(color: SaathiColors.primaryContainer, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: const BorderSide(color: SaathiColors.danger, width: 1.5),
        ),
        hintStyle: GoogleFonts.inter(
          fontSize: 14, color: SaathiColors.onSurfaceVariant, fontWeight: FontWeight.w500,
        ),
        labelStyle: GoogleFonts.inter(
          fontSize: 14, color: SaathiColors.onSurfaceVariant,
        ),
      ),

      // ── Cards ─────────────────────────────────────────────────────────────
      cardTheme: const CardThemeData(
        color: SaathiColors.surfaceContainer, // Cockpit Deck
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(4)),
          side: BorderSide(color: SaathiColors.structuralStroke, width: 1),
        ),
        margin: EdgeInsets.zero,
      ),

      // ── Chips ─────────────────────────────────────────────────────────────
      chipTheme: ChipThemeData(
        backgroundColor: SaathiColors.surfaceContainerHigh,
        labelStyle: GoogleFonts.epilogue(fontSize: 11, fontWeight: FontWeight.w700, color: SaathiColors.onSurface),
        side: const BorderSide(color: SaathiColors.outline, width: 1),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      ),

      // ── Navigation ────────────────────────────────────────────────────────
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: SaathiColors.surfaceContainerLowest,
        indicatorColor: Colors.transparent,
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const IconThemeData(color: SaathiColors.primaryContainer, size: 24);
          }
          return const IconThemeData(color: SaathiColors.onSurfaceVariant, size: 24);
        }),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          final base = GoogleFonts.epilogue(fontSize: 11, fontWeight: FontWeight.w700);
          if (states.contains(WidgetState.selected)) {
            return base.copyWith(color: SaathiColors.primaryContainer);
          }
          return base.copyWith(color: SaathiColors.onSurfaceVariant);
        }),
        elevation: 0,
        height: 64,
      ),

      // ── Snackbar ──────────────────────────────────────────────────────────
      snackBarTheme: SnackBarThemeData(
        backgroundColor: SaathiColors.surfaceContainerHigh,
        contentTextStyle: GoogleFonts.inter(color: SaathiColors.onSurface, fontSize: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        behavior: SnackBarBehavior.floating,
      ),

      // ── Dialog ────────────────────────────────────────────────────────────
      dialogTheme: DialogThemeData(
        backgroundColor: SaathiColors.surfaceContainerHigh,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
          side: const BorderSide(color: SaathiColors.structuralStroke),
        ),
        titleTextStyle: GoogleFonts.epilogue(
          fontSize: 18, fontWeight: FontWeight.w700, color: SaathiColors.onSurface,
        ),
        contentTextStyle: GoogleFonts.inter(
          fontSize: 14, color: SaathiColors.onSurfaceVariant,
        ),
      ),

      // ── Divider ───────────────────────────────────────────────────────────
      dividerTheme: const DividerThemeData(
        color: SaathiColors.structuralStroke,
        thickness: 1,
        space: 1,
      ),

      // ── Progress Indicator ────────────────────────────────────────────────
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: SaathiColors.primaryContainer,
        linearTrackColor: SaathiColors.surfaceContainerHigh,
      ),
    );
  }
}
