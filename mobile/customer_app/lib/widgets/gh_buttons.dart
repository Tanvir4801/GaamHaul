import 'package:flutter/material.dart';
import 'package:shared_package/shared_package.dart';
import '../core/theme/customer_theme.dart';

// ─────────────────────────────────────────────────────────────────────────────
// GAAMHAUL CUSTOMER — BUTTON SYSTEM
// ─────────────────────────────────────────────────────────────────────────────

/// Primary CTA
/// Use for the most important action on the screen (Submit, Confirm, Select).
class GhPrimaryButton extends StatelessWidget {
  const GhPrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
    this.icon,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: GhTokens.touchTargetPrimary,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        child: isLoading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  color: CustomerColors.onPrimary,
                ),
              )
            : icon != null
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(icon, size: GhTokens.iconMd),
                      const SizedBox(width: GhTokens.spaceXs),
                      Text(label),
                    ],
                  )
                : Text(label),
      ),
    );
  }
}

/// Secondary CTA — Outlined button.
/// Use for supporting actions (Back, View Details, Edit).
class GhSecondaryButton extends StatelessWidget {
  const GhSecondaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: GhTokens.touchTargetMin,
      child: OutlinedButton(
        onPressed: onPressed,
        child: icon != null
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(icon, size: GhTokens.iconMd),
                  const SizedBox(width: GhTokens.spaceXs),
                  Text(label),
                ],
              )
            : Text(label),
      ),
    );
  }
}

/// Destructive action button — red/error styling.
/// Use for irreversible actions (Cancel Request, Delete).
class GhDestructiveButton extends StatelessWidget {
  const GhDestructiveButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: GhTokens.touchTargetMin,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: CustomerColors.error,
          side: const BorderSide(color: CustomerColors.error, width: 1.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: icon != null
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(icon, size: GhTokens.iconMd),
                  const SizedBox(width: GhTokens.spaceXs),
                  Text(label),
                ],
              )
            : Text(label),
      ),
    );
  }
}

/// Highlight action button.
/// Use for time-sensitive primary actions.
class GhHighlightButton extends StatelessWidget {
  const GhHighlightButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
    this.icon,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: GhTokens.touchTargetPrimary,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: CustomerColors.primaryContainer,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: isLoading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2.5, color: Colors.white),
              )
            : icon != null
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(icon, size: GhTokens.iconMd),
                      const SizedBox(width: GhTokens.spaceSm),
                      Text(label),
                    ],
                  )
                : Text(label),
      ),
    );
  }
}
