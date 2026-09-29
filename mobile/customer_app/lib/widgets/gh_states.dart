import 'package:flutter/material.dart';
import '../core/theme/customer_theme.dart';
import 'package:shared_package/shared_package.dart';

// ─────────────────────────────────────────────────────────────────────────────
// GhEmptyState — No content placeholder
// ─────────────────────────────────────────────────────────────────────────────

/// Centered empty state with icon, heading, message, and optional CTA.
class GhEmptyState extends StatelessWidget {
  const GhEmptyState({
    super.key,
    required this.icon,
    required this.heading,
    required this.message,
    this.ctaLabel,
    this.onCta,
  });

  final IconData icon;
  final String heading;
  final String message;
  final String? ctaLabel;
  final VoidCallback? onCta;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(GhTokens.spaceXl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: CustomerColors.surfaceContainer,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: GhTokens.iconXxl, color: CustomerColors.onSurfaceVariant),
            ),
            const SizedBox(height: GhTokens.spaceLg),
            Text(
              heading,
              style: CustomerTextStyles.headlineSm,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: GhTokens.spaceSm),
            Text(
              message,
              style: CustomerTextStyles.bodyMd.copyWith(color: CustomerColors.onSurfaceVariant),
              textAlign: TextAlign.center,
            ),
            if (ctaLabel != null && onCta != null) ...[
              const SizedBox(height: GhTokens.spaceLg),
              SizedBox(
                width: double.infinity,
                height: GhTokens.touchTargetPrimary,
                child: ElevatedButton(
                  onPressed: onCta,
                  child: Text(ctaLabel!),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// GhLoadingState — Centered loading indicator
// ─────────────────────────────────────────────────────────────────────────────

/// Full-area loading placeholder.
class GhLoadingState extends StatelessWidget {
  const GhLoadingState({super.key, this.message});
  final String? message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircularProgressIndicator(
            color: CustomerColors.secondary,
            strokeWidth: 3,
          ),
          if (message != null) ...[
            const SizedBox(height: GhTokens.spaceMd),
            Text(
              message!,
              style: CustomerTextStyles.bodyMd.copyWith(color: CustomerColors.onSurfaceVariant),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// GhErrorState — Error display with retry
// ─────────────────────────────────────────────────────────────────────────────

/// Error state with message and optional retry action.
class GhErrorState extends StatelessWidget {
  const GhErrorState({
    super.key,
    required this.message,
    this.onRetry,
  });

  final String message;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(GhTokens.spaceXl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: CustomerColors.errorContainer,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.error_outline_rounded, size: 36, color: CustomerColors.error),
            ),
            const SizedBox(height: GhTokens.spaceMd),
            Text(
              'Something went wrong',
              style: CustomerTextStyles.headlineSm,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: GhTokens.spaceXs),
            Text(
              message,
              style: CustomerTextStyles.bodySm.copyWith(color: CustomerColors.onSurfaceVariant),
              textAlign: TextAlign.center,
            ),
            if (onRetry != null) ...[
              const SizedBox(height: GhTokens.spaceLg),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: onRetry,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Try Again'),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// GhRatingStars — Displays a star rating (read-only or interactive)
// References: Confirm_Rating.png
// ─────────────────────────────────────────────────────────────────────────────

/// Star rating display/selector.
/// When [onRatingChanged] is null, renders read-only.
class GhRatingStars extends StatelessWidget {
  const GhRatingStars({
    super.key,
    required this.rating,
    this.onRatingChanged,
    this.starSize = 36.0,
    this.count = 5,
  });

  final double rating;
  final ValueChanged<int>? onRatingChanged;
  final double starSize;
  final int count;

  bool get _isInteractive => onRatingChanged != null;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(count, (i) {
        final filled = (i + 1) <= rating;
        final half = !filled && (i + 0.5) <= rating;
        final icon = filled
            ? Icons.star_rounded
            : half
                ? Icons.star_half_rounded
                : Icons.star_outline_rounded;
        final color = filled || half ? const Color(0xFFF59E0B) : CustomerColors.outlineVariant;

        return GestureDetector(
          onTap: _isInteractive ? () => onRatingChanged!(i + 1) : null,
          child: Semantics(
            label: '${i + 1} star${i == 0 ? '' : 's'}${_isInteractive ? ', tap to rate' : ''}',
            child: Icon(icon, size: starSize, color: color),
          ),
        );
      }),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// GhSectionHeader — section title + optional trailing action
// ─────────────────────────────────────────────────────────────────────────────

/// Section heading with optional trailing text CTA.
class GhSectionHeader extends StatelessWidget {
  const GhSectionHeader({
    super.key,
    required this.title,
    this.trailing,
    this.onTrailingTap,
  });

  final String title;
  final String? trailing;
  final VoidCallback? onTrailingTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(title, style: CustomerTextStyles.headlineSm),
        ),
        if (trailing != null)
          GestureDetector(
            onTap: onTrailingTap,
            child: Text(
              trailing!,
              style: CustomerTextStyles.labelMd.copyWith(color: CustomerColors.primaryContainer),
            ),
          ),
      ],
    );
  }
}
