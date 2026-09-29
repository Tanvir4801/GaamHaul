import 'package:flutter/material.dart';
import 'package:shared_package/shared_package.dart';
import '../core/theme/customer_theme.dart';

// ─────────────────────────────────────────────────────────────────────────────
// GhStatusChip — renders a request status pill badge
// ─────────────────────────────────────────────────────────────────────────────

/// A pill-shaped status chip for a [RequestStatus].
/// Color-coded to convey urgency and phase.
class GhStatusChip extends StatelessWidget {
  const GhStatusChip({super.key, required this.status});

  final RequestStatus status;

  @override
  Widget build(BuildContext context) {
    final (label, bg, fg) = _resolve(status);
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: GhTokens.spaceMd,
        vertical: GhTokens.spaceXs,
      ),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(9999),
      ),
      child: Text(
        label,
        style: CustomerTextStyles.labelSm.copyWith(color: fg, letterSpacing: 0.5),
      ),
    );
  }

  static (String, Color, Color) _resolve(RequestStatus status) {
    return switch (status) {
      RequestStatus.open => (
          'FINDING SAATHIS',
          CustomerColors.secondary.withValues(alpha: 0.10),
          CustomerColors.secondary, // Cerulean
        ),
      RequestStatus.matched => (
          'SAATHI FOUND',
          CustomerColors.success.withValues(alpha: 0.10),
          CustomerColors.success,
        ),
      RequestStatus.inProgress => (
          'IN PROGRESS',
          CustomerColors.secondary.withValues(alpha: 0.10),
          CustomerColors.secondary, // Cerulean
        ),
      RequestStatus.completed => (
          'COMPLETED',
          CustomerColors.primaryContainer.withValues(alpha: 0.10),
          CustomerColors.primaryContainer, // Navy
        ),
      RequestStatus.cancelled => (
          'CANCELLED',
          CustomerColors.outline.withValues(alpha: 0.10),
          CustomerColors.outline, // Slate
        ),
    };
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// GhTagChip — generic text chip for cargo type, work type, labels
// ─────────────────────────────────────────────────────────────────────────────

/// Generic read-only tag chip (non-interactive).
/// Use for cargo type labels, work type badges, etc.
class GhTagChip extends StatelessWidget {
  const GhTagChip({
    super.key,
    required this.label,
    this.icon,
    this.color,
  });

  final String label;
  final IconData? icon;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final bg = (color ?? CustomerColors.primaryContainer).withValues(alpha: 0.08);
    final fg = color ?? CustomerColors.primaryContainer;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: GhTokens.spaceMd,
        vertical: GhTokens.spaceXs,
      ),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(9999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: GhTokens.iconSm, color: fg),
            const SizedBox(width: GhTokens.spaceXs),
          ],
          Text(
            label,
            style: CustomerTextStyles.labelSm.copyWith(color: fg),
          ),
        ],
      ),
    );
  }
}
