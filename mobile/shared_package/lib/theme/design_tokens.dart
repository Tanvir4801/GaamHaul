import 'package:flutter/material.dart';

/// GaamHaul Shared Design Tokens
///
/// This file contains ONLY genuinely shared primitives that are
/// independent of brand identity (Customer vs. Saathi).
///
/// Customer brand → customer_app/lib/core/theme/customer_theme.dart
/// Saathi brand   → saathi_app/lib/core/theme/saathi_theme.dart
abstract class GhTokens {
  GhTokens._();

  // ---------------------------------------------------------------------------
  // SPACING — 8pt grid
  // ---------------------------------------------------------------------------
  static const double spaceXxs = 2.0;
  static const double spaceXs = 4.0;
  static const double spaceSm = 8.0;
  static const double spaceMd = 16.0;
  static const double spaceLg = 24.0;
  static const double spaceXl = 32.0;
  static const double spaceXxl = 48.0;

  /// Standard screen edge gutter
  static const double gutter = 16.0;

  // ---------------------------------------------------------------------------
  // BORDER RADIUS
  // ---------------------------------------------------------------------------
  static const double radiusXs = 2.0;   // Saathi accent lines
  static const double radiusSm = 4.0;   // Saathi cards, buttons (machined)
  static const double radiusMd = 8.0;   // Customer inputs, small cards
  static const double radiusLg = 12.0;  // Customer cards
  static const double radiusXl = 16.0;  // Customer vehicle cards
  static const double radiusXxl = 24.0; // Customer bottom sheets
  static const double radiusFull = 9999.0; // Pills, status chips

  // ---------------------------------------------------------------------------
  // TOUCH TARGETS — WCAG + field operations
  // ---------------------------------------------------------------------------
  static const double touchTargetMin = 48.0;     // WCAG minimum
  static const double touchTargetPrimary = 56.0; // Primary CTAs
  static const double touchTargetNav = 52.0;     // Navigation items

  // ---------------------------------------------------------------------------
  // ICON SIZES
  // ---------------------------------------------------------------------------
  static const double iconSm = 16.0;
  static const double iconMd = 20.0;
  static const double iconLg = 24.0;
  static const double iconXl = 32.0;
  static const double iconXxl = 48.0;

  // ---------------------------------------------------------------------------
  // ANIMATION DURATIONS
  // ---------------------------------------------------------------------------
  static const Duration animFast = Duration(milliseconds: 120);
  static const Duration animNormal = Duration(milliseconds: 220);
  static const Duration animSlow = Duration(milliseconds: 350);

  // ---------------------------------------------------------------------------
  // ANIMATION CURVES
  // ---------------------------------------------------------------------------
  static const Curve curveEaseOut = Curves.easeOut;
  static const Curve curveEaseInOut = Curves.easeInOut;

  // ---------------------------------------------------------------------------
  // ELEVATION SHADOWS — defined as BoxShadow lists, not Material elevation
  // so each brand can override them appropriately.
  // ---------------------------------------------------------------------------

  /// Customer: warm green-tinted card shadow (Level 1)
  static List<BoxShadow> shadowCardCustomer = [
    BoxShadow(
      color: const Color(0xFF145443).withValues(alpha: 0.08),
      blurRadius: 8,
      offset: const Offset(0, 2),
      spreadRadius: -2,
    ),
  ];

  /// Customer: active/selected card shadow (Level 2)
  static List<BoxShadow> shadowActiveCustomer = [
    BoxShadow(
      color: const Color(0xFF145443).withValues(alpha: 0.14),
      blurRadius: 24,
      offset: const Offset(0, 8),
      spreadRadius: -4,
    ),
  ];

  /// Customer: modal/dialog shadow (Level 3)
  static List<BoxShadow> shadowModalCustomer = [
    BoxShadow(
      color: const Color(0xFF202522).withValues(alpha: 0.22),
      blurRadius: 40,
      offset: const Offset(0, 16),
      spreadRadius: -8,
    ),
  ];

  /// Saathi: no shadows — surface tiers only (structural border approach)
  static const List<BoxShadow> shadowSaathi = [];

  // ---------------------------------------------------------------------------
  // STROKE WIDTHS
  // ---------------------------------------------------------------------------
  static const double strokeThin = 1.0;
  static const double strokeMed = 1.5;
  static const double strokeThick = 2.0;

  // ---------------------------------------------------------------------------
  // LOCATION FRESHNESS THRESHOLDS
  // Aligned with AppConstants.locationStalenessThresholdHours = 3
  // The LOCKED business rule is 3 hours. These tokens mirror that.
  // ---------------------------------------------------------------------------
  /// Minutes after which location is considered stale.
  /// = AppConstants.locationStalenessThresholdHours * 60 = 180 minutes.
  static const int locationStaleMinutes = 180;
  /// Minutes at which UI shows a warning hint before full staleness.
  /// Set to 2/3 of the stale threshold (120 min) as a soft reminder.
  static const int locationWarnMinutes = 120;
}
