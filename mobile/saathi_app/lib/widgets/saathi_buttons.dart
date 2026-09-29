import 'package:flutter/material.dart';
import 'package:shared_package/shared_package.dart';
import '../core/theme/saathi_theme.dart';

// ─────────────────────────────────────────────────────────────────────────────
// SAATHI APP — BUTTON SYSTEM
// ─────────────────────────────────────────────────────────────────────────────

/// Primary CTA — Industrial Amber filled.
/// Use for main dispatch actions (Express Interest, Complete Haul, Go On Duty).
class SaathiPrimaryButton extends StatelessWidget {
  const SaathiPrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
    this.icon,
    this.semanticLabel,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final IconData? icon;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: semanticLabel ?? label,
      button: true,
      child: SizedBox(
        width: double.infinity,
        height: GhTokens.touchTargetPrimary,
        child: ElevatedButton(
          onPressed: isLoading ? null : onPressed,
          child: isLoading
              ? const SizedBox(
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    color: SaathiColors.onPrimary,
                  ),
                )
              : icon != null
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(icon, size: GhTokens.iconLg),
                        const SizedBox(width: GhTokens.spaceSm),
                        Text(label),
                      ],
                    )
                  : Text(label),
        ),
      ),
    );
  }
}

/// Secondary button — dark outlined.
/// Use for View Route, View Request, secondary navigation actions.
class SaathiSecondaryButton extends StatelessWidget {
  const SaathiSecondaryButton({
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
                  const SizedBox(width: GhTokens.spaceSm),
                  Text(label),
                ],
              )
            : Text(label),
      ),
    );
  }
}

/// Signal Green success button — complete haul, mark done.
class SaathiSuccessButton extends StatelessWidget {
  const SaathiSuccessButton({
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
          backgroundColor: SaathiColors.secondary,
          foregroundColor: SaathiColors.onSecondary,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(GhTokens.radiusSm)),
        ),
        child: isLoading
            ? const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(strokeWidth: 2.5, color: SaathiColors.onSecondary),
              )
            : icon != null
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(icon, size: GhTokens.iconLg),
                      const SizedBox(width: GhTokens.spaceSm),
                      Text(label),
                    ],
                  )
                : Text(label),
      ),
    );
  }
}

/// Danger button — reject, cancel, off-duty.
class SaathiDangerButton extends StatelessWidget {
  const SaathiDangerButton({
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
          foregroundColor: SaathiColors.danger,
          side: const BorderSide(color: SaathiColors.danger, width: 1.5),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(GhTokens.radiusSm)),
        ),
        child: icon != null
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
