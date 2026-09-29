import 'package:flutter/material.dart';
import 'package:shared_package/shared_package.dart';
import '../../../../core/theme/customer_theme.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class WorkTypeChip extends StatelessWidget {
  final WorkType workType;
  final bool isSelected;
  final VoidCallback onTap;

  const WorkTypeChip({
    super.key,
    required this.workType,
    required this.isSelected,
    required this.onTap,
  });

  String _getEmoji(WorkType type) {
    switch (type) {
      case WorkType.farm: return '🌾';
      case WorkType.nursery: return '🌱';
      case WorkType.construction: return '🏗';
      case WorkType.shifting: return '📦';
      case WorkType.shop: return '🏪';
      case WorkType.other: return '📍';
    }
  }

  String _getWorkName(BuildContext context, WorkType type) {
    final l10n = AppLocalizations.of(context)!;
    switch (type) {
      case WorkType.farm: return l10n.workFarm;
      case WorkType.nursery: return l10n.workNursery;
      case WorkType.construction: return l10n.workConstruction;
      case WorkType.shifting: return l10n.workShifting;
      case WorkType.shop: return l10n.workShop;
      case WorkType.other: return l10n.workOther;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: GhTokens.animFast,
        curve: GhTokens.curveEaseOut,
        padding: const EdgeInsets.symmetric(horizontal: GhTokens.spaceMd, vertical: GhTokens.spaceMd),
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
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _getEmoji(workType),
              style: const TextStyle(fontSize: 28),
            ),
            const SizedBox(height: GhTokens.spaceSm),
            Text(
              _getWorkName(context, workType),
              style: CustomerTextStyles.labelMd.copyWith(
                color: isSelected ? CustomerColors.onPrimary : CustomerColors.onSurface,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
