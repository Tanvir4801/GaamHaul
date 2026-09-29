import 'package:flutter/material.dart';
import 'package:shared_package/shared_package.dart';
import '../core/theme/saathi_theme.dart';
import 'saathi_status_badge.dart';

// ─────────────────────────────────────────────────────────────────────────────
// SaathiRequestCard — Incoming request card for the Live Radar feed
// References: saathicockpit.png (NEW REQUESTS section)
// ─────────────────────────────────────────────────────────────────────────────

/// Card shown in the incoming requests list on the cockpit.
/// Displays: vehicle type, work type, location pair, fare range, distance.
/// [onViewRequest] opens the full RequestDetails screen.
/// Uses "VIEW REQUEST → EXPRESS INTEREST" flow per product spec.
class SaathiRequestCard extends StatelessWidget {
  const SaathiRequestCard({
    super.key,
    required this.request,
    required this.onViewRequest,
    this.distanceKm,
  });

  final RequestModel request;
  final VoidCallback onViewRequest;
  /// Haversine distance in km — optional, null if vehicle location not set
  final double? distanceKm;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: SaathiColors.surfaceContainer,
        borderRadius: BorderRadius.circular(GhTokens.radiusSm),
        border: Border.all(color: SaathiColors.structuralStroke),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(GhTokens.radiusSm),
        child: InkWell(
          onTap: onViewRequest,
          borderRadius: BorderRadius.circular(GhTokens.radiusSm),
          child: Padding(
            padding: const EdgeInsets.all(GhTokens.spaceMd),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Vehicle + Distance ────────────────────────────────────
                Row(
                  children: [
                    SaathiVehicleTypeBadge(vehicleType: request.vehicleTypeRequested),
                    const Spacer(),
                    if (distanceKm != null)
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.navigation,
                            size: GhTokens.iconSm,
                            color: SaathiColors.primary,
                          ),
                          const SizedBox(width: GhTokens.spaceXxs),
                          Text(
                            '${distanceKm!.toStringAsFixed(1)} km away',
                            style: SaathiTextStyles.labelMd.copyWith(
                              color: SaathiColors.primary,
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
                const SizedBox(height: GhTokens.spaceSm),

                // ── Work description ──────────────────────────────────────
                Text(
                  '${request.workType.value.toUpperCase()} · ${request.durationType.value.toUpperCase()}',
                  style: SaathiTextStyles.bodyLg,
                ),
                const SizedBox(height: GhTokens.spaceSm),

                // ── Location pair ─────────────────────────────────────────
                const _LocationDot(color: SaathiColors.primary, label: 'PICKUP'),
                const SizedBox(height: GhTokens.spaceXs),
                const _LocationDot(color: SaathiColors.secondary, label: 'DROP-OFF'),

                const SizedBox(height: GhTokens.spaceMd),

                // ── Fare + CTA row ────────────────────────────────────────
                Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'DIRECT FARE',
                          style: SaathiTextStyles.labelSm.copyWith(
                            color: SaathiColors.onSurfaceVariant,
                          ),
                        ),
                        Text(
                          '₹${request.estimatedPriceMin.toInt()} – ₹${request.estimatedPriceMax.toInt()}',
                          style: SaathiTextStyles.headlineMd.copyWith(
                            color: SaathiColors.primary,
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    ElevatedButton.icon(
                      onPressed: onViewRequest,
                      icon: const Icon(Icons.arrow_forward, size: GhTokens.iconMd),
                      label: const Text('VIEW REQUEST'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }


}

class _LocationDot extends StatelessWidget {
  const _LocationDot({required this.color, required this.label});
  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color,
          ),
        ),
        const SizedBox(width: GhTokens.spaceSm),
        Text(
          label,
          style: SaathiTextStyles.labelSm.copyWith(color: SaathiColors.onSurfaceVariant),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// SaathiMilestoneRow — Single trip milestone status row
// References: selacted_activejobs.png (TRIP STATUS · MILESTONES)
// ─────────────────────────────────────────────────────────────────────────────

enum MilestoneStatus { completed, active, pending }

/// A single milestone row in the active haul timeline.
/// [status]: completed (green check), active (amber/active), pending (dimmed).
class SaathiMilestoneRow extends StatelessWidget {
  const SaathiMilestoneRow({
    super.key,
    required this.label,
    required this.sublabel,
    required this.status,
    this.timestamp,
  });

  final String label;
  final String sublabel;
  final MilestoneStatus status;
  final String? timestamp;

  @override
  Widget build(BuildContext context) {
    final (iconData, iconColor, textColor) = switch (status) {
      MilestoneStatus.completed => (Icons.check_circle_rounded, SaathiColors.secondary, SaathiColors.onSurface),
      MilestoneStatus.active => (Icons.radio_button_checked, SaathiColors.primary, SaathiColors.onSurface),
      MilestoneStatus.pending => (Icons.radio_button_unchecked, SaathiColors.onSurfaceVariant, SaathiColors.onSurfaceVariant),
    };

    return Opacity(
      opacity: status == MilestoneStatus.pending ? 0.45 : 1.0,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Icon(iconData, size: GhTokens.iconLg, color: iconColor),
            ],
          ),
          const SizedBox(width: GhTokens.spaceSm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        label,
                        style: SaathiTextStyles.labelMd.copyWith(color: textColor),
                      ),
                    ),
                    if (timestamp != null)
                      Text(
                        timestamp!,
                        style: SaathiTextStyles.bodySm.copyWith(color: SaathiColors.onSurfaceVariant),
                      ),
                  ],
                ),
                if (sublabel.isNotEmpty) ...[
                  const SizedBox(height: GhTokens.spaceXxs),
                  Text(sublabel, style: SaathiTextStyles.bodySm),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
