import 'package:flutter/material.dart';
import 'package:shared_package/shared_package.dart';
import '../../../../core/theme/customer_theme.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class VehicleSelectionCard extends StatelessWidget {
  final VehicleType vehicleType;
  final bool isSelected;
  final VoidCallback onTap;

  const VehicleSelectionCard({
    super.key,
    required this.vehicleType,
    required this.isSelected,
    required this.onTap,
  });

  String _getVehicleName(BuildContext context, VehicleType type) {
    final l10n = AppLocalizations.of(context)!;
    switch (type) {
      case VehicleType.eLoader: return l10n.vehicleELoaderName;
      case VehicleType.pickup: return l10n.vehiclePickupName;
      case VehicleType.tempo: return l10n.vehicleTempoName;
      case VehicleType.miniTruck: return l10n.vehicleMiniTruckName;
      case VehicleType.tractor: return l10n.vehicleTractorName;
    }
  }

  String _getVehicleDesc(BuildContext context, VehicleType type) {
    final l10n = AppLocalizations.of(context)!;
    switch (type) {
      case VehicleType.eLoader: return l10n.vehicleELoaderDesc;
      case VehicleType.pickup: return l10n.vehiclePickupDesc;
      case VehicleType.tempo: return l10n.vehicleTempoDesc;
      case VehicleType.miniTruck: return l10n.vehicleMiniTruckDesc;
      case VehicleType.tractor: return l10n.vehicleTractorDesc;
    }
  }
  
  String _getCapacity(VehicleType type) {
    switch (type) {
      case VehicleType.eLoader: return '500 KG';
      case VehicleType.pickup: return '1.5 T';
      case VehicleType.tempo: return '1 T';
      case VehicleType.miniTruck: return '2.5 T';
      case VehicleType.tractor: return '3 T+';
    }
  }
  
  IconData _getIcon(VehicleType type) {
    switch (type) {
      case VehicleType.eLoader: return Icons.electric_rickshaw;
      case VehicleType.pickup: return Icons.local_shipping_outlined;
      case VehicleType.tempo: return Icons.airport_shuttle_outlined;
      case VehicleType.miniTruck: return Icons.local_shipping;
      case VehicleType.tractor: return Icons.agriculture;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: GhTokens.animFast,
        curve: GhTokens.curveEaseOut,
        margin: const EdgeInsets.only(bottom: GhTokens.spaceMd),
        padding: const EdgeInsets.all(GhTokens.spaceMd),
        decoration: BoxDecoration(
          color: isSelected ? CustomerColors.inversePrimary.withValues(alpha: 0.15) : CustomerColors.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(GhTokens.radiusXl),
          border: Border.all(
            color: isSelected ? CustomerColors.secondary : CustomerColors.outlineVariant,
            width: isSelected ? 2.0 : 1.0,
          ),
          boxShadow: isSelected ? GhTokens.shadowActiveCustomer : GhTokens.shadowCardCustomer,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(GhTokens.spaceMd),
              decoration: BoxDecoration(
                color: isSelected ? CustomerColors.secondary : CustomerColors.surfaceContainerLow,
                shape: BoxShape.circle,
              ),
              child: Icon(
                _getIcon(vehicleType),
                color: isSelected ? CustomerColors.onSecondary : CustomerColors.primaryContainer,
                size: GhTokens.iconLg,
              ),
            ),
            const SizedBox(width: GhTokens.spaceMd),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _getVehicleName(context, vehicleType),
                        style: CustomerTextStyles.titleLg,
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: CustomerColors.surfaceContainerHigh,
                          borderRadius: BorderRadius.circular(GhTokens.radiusSm),
                        ),
                        child: Text(
                          _getCapacity(vehicleType),
                          style: CustomerTextStyles.labelSm,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: GhTokens.spaceXs),
                  Text(
                    _getVehicleDesc(context, vehicleType),
                    style: CustomerTextStyles.bodySm,
                  ),
                ],
              ),
            ),
            if (isSelected) ...[
              const SizedBox(width: GhTokens.spaceSm),
              const Icon(Icons.check_circle, color: CustomerColors.secondary),
            ],
          ],
        ),
      ),
    );
  }
}
