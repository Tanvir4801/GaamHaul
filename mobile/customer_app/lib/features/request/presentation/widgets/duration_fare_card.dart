import 'package:flutter/material.dart';
import 'package:shared_package/shared_package.dart';
import '../../../../core/theme/customer_theme.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DurationFareCard extends StatelessWidget {
  final DurationType durationType;
  final PriceRange? estimatedPrice;
  final bool isSelected;
  final VoidCallback onTap;
  final Widget? child;

  const DurationFareCard({
    super.key,
    required this.durationType,
    this.estimatedPrice,
    required this.isSelected,
    required this.onTap,
    this.child,
  });

  String _getDurationName(BuildContext context, DurationType type) {
    final l10n = AppLocalizations.of(context)!;
    switch (type) {
      case DurationType.oneHour: return l10n.durationOneHour;
      case DurationType.twoHour: return l10n.durationTwoHours;
      case DurationType.halfDay: return l10n.durationHalfDay;
      case DurationType.fullDay: return l10n.durationFullDay;
      case DurationType.custom: return 'Custom';
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: GhTokens.animFast,
        margin: const EdgeInsets.only(bottom: GhTokens.spaceMd),
        padding: const EdgeInsets.all(GhTokens.spaceMd),
        decoration: BoxDecoration(
          color: isSelected ? CustomerColors.primaryContainer : CustomerColors.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(GhTokens.radiusMd),
          border: Border.all(
            color: isSelected ? CustomerColors.primaryContainer : CustomerColors.outlineVariant,
            width: 1.0,
          ),
          boxShadow: isSelected ? GhTokens.shadowCardCustomer : null,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _getDurationName(context, durationType),
                  style: CustomerTextStyles.titleLg.copyWith(
                    color: isSelected ? CustomerColors.onPrimary : CustomerColors.onSurface,
                  ),
                ),
                if (isSelected)
                  Icon(Icons.check_circle, color: CustomerColors.onPrimary)
                else
                  Icon(Icons.circle_outlined, color: CustomerColors.outlineVariant),
              ],
            ),
            if (estimatedPrice != null) ...[
              const SizedBox(height: GhTokens.spaceSm),
              Text(
                '₹${estimatedPrice!.min} – ₹${estimatedPrice!.max}',
                style: CustomerTextStyles.bodyMd.copyWith(
                  color: isSelected ? CustomerColors.inversePrimary : CustomerColors.secondary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
            if (child != null) ...[
              const SizedBox(height: GhTokens.spaceMd),
              child!,
            ]
          ],
        ),
      ),
    );
  }
}
