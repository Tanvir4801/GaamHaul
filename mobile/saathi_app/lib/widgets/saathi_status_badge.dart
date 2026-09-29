import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shared_package/shared_package.dart';
import '../core/theme/saathi_theme.dart';

// ─────────────────────────────────────────────────────────────────────────────
// SaathiVehicleStatusBadge — pill showing vehicle operational state
// ─────────────────────────────────────────────────────────────────────────────

/// Small pill badge for vehicle status (on_duty, off_duty, busy).
class SaathiVehicleStatusBadge extends StatelessWidget {
  const SaathiVehicleStatusBadge({super.key, required this.status});
  final VehicleStatus status;

  @override
  Widget build(BuildContext context) {
    final (label, bg, fg, dot) = _resolve(status);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: GhTokens.spaceSm, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(GhTokens.radiusSm),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(shape: BoxShape.circle, color: dot),
          ),
          const SizedBox(width: GhTokens.spaceXs),
          Text(label, style: SaathiTextStyles.labelSm.copyWith(color: fg)),
        ],
      ),
    );
  }

  static (String, Color, Color, Color) _resolve(VehicleStatus s) {
    return switch (s) {
      VehicleStatus.onDuty => (
          'ACTIVE ON DUTY',
          SaathiColors.secondary.withValues(alpha: 0.10),
          SaathiColors.secondary,
          SaathiColors.secondary,
        ),
      VehicleStatus.offDuty => (
          'STANDBY',
          SaathiColors.surfaceContainerHigh,
          SaathiColors.onSurfaceVariant,
          SaathiColors.onSurfaceVariant,
        ),
      VehicleStatus.busy => (
          'BUSY · ON HAUL',
          SaathiColors.primaryContainer.withValues(alpha: 0.12),
          SaathiColors.primaryContainer,
          SaathiColors.primaryContainer,
        ),
    };
  }
}

/// Approval status badge (for verified/pending/rejected admin state)
class SaathiApprovalBadge extends StatelessWidget {
  const SaathiApprovalBadge({super.key, required this.status});
  final VerificationStatus status;

  @override
  Widget build(BuildContext context) {
    final (label, fg) = _resolve(status);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: GhTokens.spaceSm, vertical: 4),
      decoration: BoxDecoration(
        color: fg.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(GhTokens.radiusSm),
        border: Border.all(color: fg.withValues(alpha: 0.25)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(_icon(status), size: 12, color: fg),
          const SizedBox(width: GhTokens.spaceXs),
          Text(label, style: SaathiTextStyles.labelSm.copyWith(color: fg)),
        ],
      ),
    );
  }

  static (String, Color) _resolve(VerificationStatus s) {
    return switch (s) {
      VerificationStatus.approved => ('APPROVED', SaathiColors.secondary),
      VerificationStatus.pending => ('PENDING REVIEW', SaathiColors.primary),
      VerificationStatus.rejected => ('REJECTED', SaathiColors.danger),
    };
  }

  static IconData _icon(VerificationStatus s) {
    return switch (s) {
      VerificationStatus.approved => Icons.verified,
      VerificationStatus.pending => Icons.schedule,
      VerificationStatus.rejected => Icons.cancel,
    };
  }
}

/// Vehicle type chip for incoming request card header
class SaathiVehicleTypeBadge extends StatelessWidget {
  const SaathiVehicleTypeBadge({super.key, required this.vehicleType});
  final VehicleType vehicleType;

  @override
  Widget build(BuildContext context) {
    final label = switch (vehicleType) {
      VehicleType.eLoader => 'E-LOADER',
      VehicleType.pickup => 'PICKUP (પિકઅપ)',
      VehicleType.tempo => 'TEMPO',
      VehicleType.miniTruck => 'MINI TRUCK',
      VehicleType.tractor => 'TRACTOR',
    };
    final icon = switch (vehicleType) {
      VehicleType.eLoader => Icons.electric_rickshaw,
      VehicleType.pickup || VehicleType.miniTruck => Icons.local_shipping,
      VehicleType.tempo => Icons.airport_shuttle,
      VehicleType.tractor => Icons.agriculture,
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: GhTokens.spaceSm, vertical: 4),
      decoration: BoxDecoration(
        color: SaathiColors.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(GhTokens.radiusSm),
        border: Border.all(color: SaathiColors.outline),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: GhTokens.iconSm, color: SaathiColors.primary),
          const SizedBox(width: GhTokens.spaceXs),
          Text(label, style: SaathiTextStyles.labelSm.copyWith(color: SaathiColors.onSurface)),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// SaathiVehicleCard — Vehicle management card
// References: vehicle_management.png
// ─────────────────────────────────────────────────────────────────────────────

/// Full vehicle card for the vehicle management tab.
/// Shows photo, type, registration, payload, duty state, and actions.
/// RC photos are NEVER shown here.
class SaathiVehicleCard extends StatelessWidget {
  const SaathiVehicleCard({
    super.key,
    required this.vehicle,
    required this.isActive,
    required this.onToggleDuty,
    this.onSwitchTo,
    this.isLoading = false,
  });

  final VehicleModel vehicle;
  /// True = this vehicle is the currently on-duty vehicle
  final bool isActive;
  final VoidCallback onToggleDuty;
  /// Null if this IS the active vehicle (no switch needed)
  final VoidCallback? onSwitchTo;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: SaathiColors.surfaceContainer,
        borderRadius: BorderRadius.circular(GhTokens.radiusSm),
        border: Border.all(
          color: isActive
              ? SaathiColors.activeHaulBorder.withValues(alpha: 0.40)
              : SaathiColors.structuralStroke,
          width: isActive ? GhTokens.strokeThick : GhTokens.strokeThin,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Status badges row ─────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(
              GhTokens.spaceMd, GhTokens.spaceMd, GhTokens.spaceMd, 0,
            ),
            child: Row(
              children: [
                SaathiVehicleStatusBadge(status: vehicle.status),
                const SizedBox(width: GhTokens.spaceSm),
                SaathiApprovalBadge(status: VerificationStatus.approved),
              ],
            ),
          ),

          // ── Vehicle info row ─────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.all(GhTokens.spaceMd),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Vehicle photo (NOT RC)
                _VehiclePhoto(photoUrl: vehicle.photoUrl, vehicleType: vehicle.type),
                const SizedBox(width: GhTokens.spaceMd),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _vehicleTypeLabel(vehicle.type),
                        style: SaathiTextStyles.headlineMd,
                      ),
                      const SizedBox(height: GhTokens.spaceXs),
                      Text(
                        vehicle.registrationNumber,
                        style: SaathiTextStyles.labelMd.copyWith(color: SaathiColors.primary),
                      ),
                      const SizedBox(height: GhTokens.spaceSm),
                      Text(
                        _payloadLabel(vehicle.type),
                        style: SaathiTextStyles.bodySm.copyWith(color: SaathiColors.onSurfaceVariant),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const Divider(color: SaathiColors.structuralStroke, height: 1),

          // ── Action button ─────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.all(GhTokens.spaceMd),
            child: isActive
                ? OutlinedButton.icon(
                    onPressed: isLoading ? null : onToggleDuty,
                    icon: const Icon(Icons.power_settings_new, size: GhTokens.iconMd),
                    label: const Text('SET OFF DUTY · બંધ કરો'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: SaathiColors.danger,
                      side: const BorderSide(color: SaathiColors.danger),
                    ),
                  )
                : ElevatedButton(
                    onPressed: isLoading ? null : onSwitchTo,
                    child: const Text('SWITCH TO THIS VEHICLE (આ વાહન ચાલુ કરો)'),
                  ),
          ),
        ],
      ),
    );
  }

  String _vehicleTypeLabel(VehicleType t) {
    return switch (t) {
      VehicleType.eLoader => 'E-Loader / Chota Hathi',
      VehicleType.pickup => 'Pickup (1.5T)',
      VehicleType.tempo => 'Tempo / Eicher',
      VehicleType.miniTruck => 'Mini Truck',
      VehicleType.tractor => 'Tractor + Trolley',
    };
  }

  String _payloadLabel(VehicleType t) {
    return switch (t) {
      VehicleType.eLoader => 'PAYLOAD  500–750 kg',
      VehicleType.pickup => 'PAYLOAD  1,000–1,500 kg',
      VehicleType.tempo => 'PAYLOAD  2,000–3,000 kg',
      VehicleType.miniTruck => 'PAYLOAD  3,000–5,000 kg',
      VehicleType.tractor => 'PAYLOAD  3,000–6,000 kg',
    };
  }
}

class _VehiclePhoto extends StatelessWidget {
  const _VehiclePhoto({required this.photoUrl, required this.vehicleType});
  final String photoUrl;
  final VehicleType vehicleType;

  @override
  Widget build(BuildContext context) {
    final fallbackIcon = switch (vehicleType) {
      VehicleType.eLoader => Icons.electric_rickshaw,
      VehicleType.pickup || VehicleType.miniTruck => Icons.local_shipping,
      VehicleType.tempo => Icons.airport_shuttle,
      VehicleType.tractor => Icons.agriculture,
    };

    final fallbackWidget = Container(
      width: 88,
      height: 72,
      decoration: BoxDecoration(
        color: SaathiColors.surfaceContainerLowest,
        border: Border.all(color: SaathiColors.structuralStroke),
      ),
      child: Center(
        child: Icon(fallbackIcon, size: 32, color: SaathiColors.onSurfaceVariant),
      ),
    );

    return ClipRRect(
      borderRadius: BorderRadius.circular(GhTokens.radiusSm),
      child: (photoUrl.trim().isEmpty)
          ? fallbackWidget
          : CachedNetworkImage(
              imageUrl: photoUrl,
              width: 88,
              height: 72,
              fit: BoxFit.cover,
              placeholder: (context, url) => Container(
                width: 88,
                height: 72,
                decoration: BoxDecoration(
                  color: SaathiColors.surfaceContainerLowest,
                  border: Border.all(color: SaathiColors.structuralStroke),
                ),
                child: const Center(child: CircularProgressIndicator(strokeWidth: 2, color: SaathiColors.primary)),
              ),
              errorWidget: (context, url, error) => fallbackWidget,
            ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Saathi state widgets
// ─────────────────────────────────────────────────────────────────────────────

/// Full-area loading state for Saathi screens.
class SaathiLoadingState extends StatelessWidget {
  const SaathiLoadingState({super.key, this.message});
  final String? message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircularProgressIndicator(color: SaathiColors.primary, strokeWidth: 3),
          if (message != null) ...[
            const SizedBox(height: GhTokens.spaceMd),
            Text(message!, style: SaathiTextStyles.bodySm, textAlign: TextAlign.center),
          ],
        ],
      ),
    );
  }
}

/// Empty state for Saathi screens.
class SaathiEmptyState extends StatelessWidget {
  const SaathiEmptyState({
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
                color: SaathiColors.surfaceContainerHigh,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: GhTokens.iconXxl, color: SaathiColors.onSurfaceVariant),
            ),
            const SizedBox(height: GhTokens.spaceLg),
            Text(heading, style: SaathiTextStyles.headlineMd, textAlign: TextAlign.center),
            const SizedBox(height: GhTokens.spaceSm),
            Text(
              message,
              style: SaathiTextStyles.bodySm.copyWith(color: SaathiColors.onSurfaceVariant),
              textAlign: TextAlign.center,
            ),
            if (ctaLabel != null && onCta != null) ...[
              const SizedBox(height: GhTokens.spaceLg),
              ElevatedButton(onPressed: onCta, child: Text(ctaLabel!)),
            ],
          ],
        ),
      ),
    );
  }
}

/// Error state for Saathi screens.
class SaathiErrorState extends StatelessWidget {
  const SaathiErrorState({super.key, required this.message, this.onRetry});
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
                color: SaathiColors.danger.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.warning_amber_rounded, size: 36, color: SaathiColors.danger),
            ),
            const SizedBox(height: GhTokens.spaceMd),
            Text('Error', style: SaathiTextStyles.headlineMd, textAlign: TextAlign.center),
            const SizedBox(height: GhTokens.spaceXs),
            Text(
              message,
              style: SaathiTextStyles.bodySm.copyWith(color: SaathiColors.onSurfaceVariant),
              textAlign: TextAlign.center,
            ),
            if (onRetry != null) ...[
              const SizedBox(height: GhTokens.spaceLg),
              OutlinedButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh),
                label: const Text('RETRY'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
