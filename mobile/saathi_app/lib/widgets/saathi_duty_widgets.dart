import 'package:flutter/material.dart';
import 'package:shared_package/shared_package.dart';
import '../core/theme/saathi_theme.dart';

// ─────────────────────────────────────────────────────────────────────────────
// SaathiDutyCard — ON DUTY / OFF DUTY cockpit status card
// References: saathicockpit.png
// ─────────────────────────────────────────────────────────────────────────────

/// Displays the current duty state of the Saathi's active vehicle.
/// [status] must be one of the real vehicle statuses: onDuty, offDuty, busy.
/// [onToggleDuty] is the callback to go on/off duty (triggers AvailabilityService).
/// No GPS/location logic here — that belongs in AvailabilityService.
class SaathiDutyCard extends StatelessWidget {
  const SaathiDutyCard({
    super.key,
    required this.vehicleStatus,
    required this.vehicleLabel,
    required this.onToggleDuty,
    this.isLoading = false,
  });

  final VehicleStatus vehicleStatus;
  /// Human-readable label, e.g., "Bolero Pickup · GJ-23-AX-8912"
  final String vehicleLabel;
  final VoidCallback onToggleDuty;
  final bool isLoading;

  bool get _isOnDuty => vehicleStatus == VehicleStatus.onDuty;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: GhTokens.animNormal,
      curve: GhTokens.curveEaseOut,
      decoration: BoxDecoration(
        color: SaathiColors.surfaceContainer,
        borderRadius: BorderRadius.circular(GhTokens.radiusSm),
        border: Border.all(
          color: _isOnDuty
              ? SaathiColors.activeHaulBorder.withValues(alpha: 0.40)
              : SaathiColors.structuralStroke,
          width: GhTokens.strokeThick,
        ),
      ),
      padding: const EdgeInsets.all(GhTokens.spaceLg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ── Status header ──────────────────────────────────────────────────
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              AnimatedContainer(
                duration: GhTokens.animNormal,
                width: 16,
                height: 16,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _isOnDuty ? SaathiColors.onDutyGreen : SaathiColors.onSurfaceVariant,
                ),
              ),
              const SizedBox(width: GhTokens.spaceMd),
              Expanded(
                child: Text(
                  _isOnDuty ? 'ON DUTY' : 'OFF DUTY',
                  style: SaathiTextStyles.headlineLg.copyWith(
                    color: _isOnDuty ? SaathiColors.onDutyGreen : SaathiColors.onSurfaceVariant,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: GhTokens.spaceMd),
          
          // ── Context text ───────────────────────────────────────────────────
          Text(
            _isOnDuty
                ? 'Receiving nearby requests...'
                : 'You are currently off duty. Go Hajar to receive requests.',
            style: SaathiTextStyles.bodyMd.copyWith(color: SaathiColors.onSurfaceVariant),
          ),
          const SizedBox(height: GhTokens.spaceXl),

          // ── Toggle button ─────────────────────────────────────────────────
          ElevatedButton.icon(
            onPressed: isLoading ? null : onToggleDuty,
            style: ElevatedButton.styleFrom(
              backgroundColor: _isOnDuty
                  ? SaathiColors.surfaceContainerHigh
                  : SaathiColors.primaryContainer,
              foregroundColor: _isOnDuty ? SaathiColors.onSurface : SaathiColors.onPrimary,
              side: _isOnDuty ? const BorderSide(color: SaathiColors.structuralStroke) : BorderSide.none,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(GhTokens.radiusSm),
              ),
            ),
            icon: isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2, color: SaathiColors.primary),
                  )
                : Icon(
                    _isOnDuty ? Icons.power_settings_new : Icons.power_settings_new,
                    size: GhTokens.iconMd,
                  ),
            label: Text(_isOnDuty ? 'GO OFF DUTY' : 'HAJAR / ON DUTY'),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// SaathiLocationStamp — Location name + timestamp + refresh
// References: saathicockpit.png
// ─────────────────────────────────────────────────────────────────────────────

/// Displays the vehicle's last known location and age of the reading.
/// [lastUpdatedAt] is the Firestore Timestamp of the last location snapshot.
/// [onRefresh] triggers AvailabilityService.refreshLocation() in the caller.
/// IMPORTANT: Never shows "Live GPS" — location is snapshot-based.
class SaathiLocationStamp extends StatelessWidget {
  const SaathiLocationStamp({
    super.key,
    this.locationName,
    this.lastUpdatedAt,
    required this.onRefresh,
    this.isRefreshing = false,
  });

  final String? locationName;
  final DateTime? lastUpdatedAt;
  final VoidCallback onRefresh;
  final bool isRefreshing;

  @override
  Widget build(BuildContext context) {
    final isStale = _isStale(lastUpdatedAt);
    final isWarn = _isWarn(lastUpdatedAt);

    if (isStale) {
      return Container(
        decoration: BoxDecoration(
          color: SaathiColors.danger.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(GhTokens.radiusSm),
          border: Border.all(color: SaathiColors.danger.withValues(alpha: 0.3)),
        ),
        padding: const EdgeInsets.all(GhTokens.spaceMd),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.warning_amber_rounded, color: SaathiColors.danger, size: GhTokens.iconMd),
                const SizedBox(width: GhTokens.spaceXs),
                Text('LOCATION REQUIRED', style: SaathiTextStyles.labelMd.copyWith(color: SaathiColors.danger)),
              ],
            ),
            const SizedBox(height: GhTokens.spaceXs),
            Text(
              'Update your location to receive nearby requests.',
              style: SaathiTextStyles.bodySm.copyWith(color: SaathiColors.onSurface),
            ),
            const SizedBox(height: GhTokens.spaceMd),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: isRefreshing ? null : onRefresh,
                icon: isRefreshing
                    ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: SaathiColors.onPrimary))
                    : const Icon(Icons.my_location),
                label: const Text('REFRESH LOCATION'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: SaathiColors.danger,
                  foregroundColor: SaathiColors.onPrimary,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(GhTokens.radiusSm)),
                ),
              ),
            ),
          ],
        ),
      );
    }

    final ageText = _formatAge(lastUpdatedAt);

    return Container(
      decoration: BoxDecoration(
        color: SaathiColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(GhTokens.radiusSm),
        border: Border.all(color: SaathiColors.structuralStroke),
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: GhTokens.spaceMd,
        vertical: GhTokens.spaceSm,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.location_on_outlined,
                size: GhTokens.iconMd,
                color: SaathiColors.onSurfaceVariant,
              ),
              const SizedBox(width: GhTokens.spaceXs),
              Expanded(
                child: Text(
                  locationName ?? 'Location updated',
                  style: SaathiTextStyles.bodyMd.copyWith(color: SaathiColors.onSurface),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: GhTokens.spaceXs),
          Row(
            children: [
              Text(
                ageText,
                style: SaathiTextStyles.bodySm.copyWith(
                  color: isWarn ? SaathiColors.primary : SaathiColors.onSurfaceVariant,
                ),
              ),
              const Spacer(),
              _RefreshButton(onRefresh: onRefresh, isRefreshing: isRefreshing),
            ],
          ),
        ],
      ),
    );
  }

  String _formatAge(DateTime? dt) {
    if (dt == null) return 'Location not updated';
    final diff = DateTime.now().difference(dt);
    if (diff.inMinutes < 1) return 'Location updated just now';
    if (diff.inMinutes < 60) return 'Location updated ${diff.inMinutes} min ago';
    if (diff.inHours < 24) return 'Location updated ${diff.inHours}h ago';
    return 'Location updated ${diff.inDays}d ago';
  }

  bool _isStale(DateTime? dt) {
    if (dt == null) return true;
    return DateTime.now().difference(dt).inMinutes >= GhTokens.locationStaleMinutes;
  }

  bool _isWarn(DateTime? dt) {
    if (dt == null) return false;
    return DateTime.now().difference(dt).inMinutes >= GhTokens.locationWarnMinutes;
  }
}

class _RefreshButton extends StatelessWidget {
  const _RefreshButton({required this.onRefresh, required this.isRefreshing});
  final VoidCallback onRefresh;
  final bool isRefreshing;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isRefreshing ? null : onRefresh,
      child: Semantics(
        label: 'Refresh location',
        button: true,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: GhTokens.spaceSm, vertical: 4),
          decoration: BoxDecoration(
            color: SaathiColors.primaryContainer.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(GhTokens.radiusSm),
          ),
          child: isRefreshing
              ? const SizedBox(
                  width: 14,
                  height: 14,
                  child: CircularProgressIndicator(strokeWidth: 2, color: SaathiColors.primary),
                )
              : Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.refresh, size: 14, color: SaathiColors.primary),
                    const SizedBox(width: 4),
                    Text(
                      'REFRESH',
                      style: SaathiTextStyles.labelSm.copyWith(color: SaathiColors.primary),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// SaathiActivityStats — Today's stats display (requests received / interested)
// References: saathicockpit.png (TODAY'S ACTIVITY section)
// ─────────────────────────────────────────────────────────────────────────────

/// Two-column stats card for the cockpit today's activity section.
class SaathiActivityStats extends StatelessWidget {
  const SaathiActivityStats({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: SaathiColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(GhTokens.radiusSm),
        border: Border.all(color: SaathiColors.structuralStroke),
      ),
      padding: const EdgeInsets.all(GhTokens.spaceLg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'TODAY\'S ACTIVITY',
            style: SaathiTextStyles.labelSm.copyWith(color: SaathiColors.onSurfaceVariant),
          ),
          const SizedBox(height: GhTokens.spaceSm),
          Text(
            'Activity summaries will appear here as your GaamHaul work history grows.',
            style: SaathiTextStyles.bodySm.copyWith(color: SaathiColors.onSurfaceVariant),
          ),
        ],
      ),
    );
  }
}
