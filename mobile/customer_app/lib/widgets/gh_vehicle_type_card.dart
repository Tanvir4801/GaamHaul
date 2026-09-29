import 'package:flutter/material.dart';
import 'package:shared_package/shared_package.dart';
import '../core/theme/customer_theme.dart';

// ─────────────────────────────────────────────────────────────────────────────
// GhVehicleTypeCard — Vehicle selection card for request flow
// References: RequestFlow.png, Customer_home.png
// ─────────────────────────────────────────────────────────────────────────────

/// Metadata for the 5 locked MVP vehicle types.
class VehicleTypeMeta {
  const VehicleTypeMeta({
    required this.localLabel,    // Gujarati/local display name
    required this.englishLabel,  // English label
    required this.icon,
    required this.capacityHint,
  });

  final String localLabel;
  final String englishLabel;
  final IconData icon;
  final String capacityHint;

  static const Map<VehicleType, VehicleTypeMeta> all = {
    VehicleType.eLoader: VehicleTypeMeta(
      localLabel: 'ઈ-લોડર / ઇ-લોડ',
      englishLabel: 'E-Loader / Chota Hathi',
      icon: Icons.electric_rickshaw,
      capacityHint: '500–750 kg',
    ),
    VehicleType.pickup: VehicleTypeMeta(
      localLabel: 'પિકઅપ',
      englishLabel: 'Pickup (1.5T)',
      icon: Icons.local_shipping,
      capacityHint: '1,000–1,500 kg',
    ),
    VehicleType.tempo: VehicleTypeMeta(
      localLabel: 'ટેમ્પો',
      englishLabel: 'Tempo / Eicher',
      icon: Icons.airport_shuttle,
      capacityHint: '2,000–3,000 kg',
    ),
    VehicleType.miniTruck: VehicleTypeMeta(
      localLabel: 'મિની ટ્રક',
      englishLabel: 'Mini Truck',
      icon: Icons.fire_truck,
      capacityHint: '3,000–5,000 kg',
    ),
    VehicleType.tractor: VehicleTypeMeta(
      localLabel: 'ટ્રેક્ટર + ટ્રોલી',
      englishLabel: 'Tractor + Trolley',
      icon: Icons.agriculture,
      capacityHint: '3,000–6,000 kg',
    ),
  };
}

/// Vehicle type selection card used in the request flow.
/// Displays: icon, local label, English label, capacity hint.
/// Supports: selected, unselected, disabled states.
class GhVehicleTypeCard extends StatelessWidget {
  const GhVehicleTypeCard({
    super.key,
    required this.vehicleType,
    required this.isSelected,
    required this.onTap,
    this.isDisabled = false,
    this.estimatedFareRange,
  });

  final VehicleType vehicleType;
  final bool isSelected;
  final VoidCallback? onTap;
  final bool isDisabled;
  /// Optional — only shown if supplied by the rate-card calculator
  final PriceRange? estimatedFareRange;

  @override
  Widget build(BuildContext context) {
    final meta = VehicleTypeMeta.all[vehicleType]!;
    final effectiveOpacity = isDisabled ? 0.42 : 1.0;

    return Opacity(
      opacity: effectiveOpacity,
      child: AnimatedContainer(
        duration: GhTokens.animNormal,
        curve: GhTokens.curveEaseOut,
        decoration: BoxDecoration(
          color: isSelected
              ? CustomerColors.secondary.withValues(alpha: 0.02)
              : CustomerColors.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected
                ? CustomerColors.secondary // Cerulean
                : const Color(0xFFD1D9E6),
            width: isSelected ? 2.0 : 1.0,
          ),
          boxShadow: isSelected ? GhTokens.shadowCardCustomer : null,
        ),
        child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          child: InkWell(
            onTap: isDisabled ? null : onTap,
            borderRadius: BorderRadius.circular(8),
            child: Padding(
              padding: const EdgeInsets.all(GhTokens.spaceMd),
              child: Row(
                children: [
                  // Vehicle Icon
                  AnimatedContainer(
                    duration: GhTokens.animNormal,
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: isSelected
                          ? CustomerColors.secondary
                          : CustomerColors.surfaceContainer,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      meta.icon,
                      size: GhTokens.iconXl,
                      color: isSelected
                          ? CustomerColors.onPrimary
                          : CustomerColors.primaryContainer,
                      semanticLabel: meta.englishLabel,
                    ),
                  ),
                  const SizedBox(width: GhTokens.spaceMd),
                  // Labels + capacity
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          meta.englishLabel,
                          style: CustomerTextStyles.titleMd.copyWith(
                            color: isSelected
                                ? CustomerColors.secondary
                                : CustomerColors.onSurface,
                          ),
                        ),
                        const SizedBox(height: GhTokens.spaceXs),
                        Text(
                          meta.localLabel,
                          style: CustomerTextStyles.bodySm,
                        ),
                        if (meta.capacityHint.isNotEmpty) ...[
                          const SizedBox(height: GhTokens.spaceXs),
                          Text(
                            meta.capacityHint,
                            style: CustomerTextStyles.bodySm.copyWith(
                              color: CustomerColors.onSurfaceVariant,
                            ),
                          ),
                        ],
                        if (estimatedFareRange != null) ...[
                          const SizedBox(height: GhTokens.spaceXs),
                          Text(
                            '₹${estimatedFareRange!.min.toInt()}–₹${estimatedFareRange!.max.toInt()}',
                            style: CustomerTextStyles.headlineSm.copyWith(
                              color: CustomerColors.primaryContainer, // Navy
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  // Selected indicator
                  if (isSelected)
                    Icon(
                      Icons.check_circle_rounded,
                      color: CustomerColors.secondary, // Cerulean
                      size: GhTokens.iconLg,
                      semanticLabel: 'Selected',
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
