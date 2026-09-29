import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shared_package/shared_package.dart';
import '../core/theme/customer_theme.dart';
import 'gh_vehicle_type_card.dart';

// ─────────────────────────────────────────────────────────────────────────────
// GhSaathiCard — Interested Saathi card for the waiting/selection screen
// References: IntrestedSaathi.png
// Data sources: users/{saathiId}, vahan_saathis/{saathiId}, vehicles/{vehicleId}
// ─────────────────────────────────────────────────────────────────────────────

/// Data container for rendering a Saathi card.
/// Populated from real Firestore documents per Founder-approved Option A.
/// Only exposes fields permitted by Firestore security rules and product design.
class SaathiCardData {
  const SaathiCardData({
    required this.saathiId,
    required this.name,
    required this.vehicleType,
    required this.vehicleId,
    required this.ratingAvg,
    required this.completedTrips,
    this.vehiclePhotoUrl,
    this.vehicleRegistrationNumber,
    this.markedAt,
  });

  final String saathiId;
  final String name;
  final VehicleType vehicleType;
  final String vehicleId;
  final double ratingAvg;
  final int completedTrips;
  /// From VehicleModel.photoUrl — vehicle face photo (NOT RC).
  final String? vehiclePhotoUrl;
  /// Registration number to show (e.g. GJ-23-AX-8912)
  final String? vehicleRegistrationNumber;
  /// When the Saathi expressed interest
  final DateTime? markedAt;
}

/// Card showing an interested Saathi during the waiting/selection stage.
/// Displays name, vehicle type, rating, and optional vehicle photo.
/// Exposes [onSelect] for the customer to select this Saathi.
/// Phone/WhatsApp contact is NOT shown here — only at confirmed stage.
class GhSaathiCard extends StatelessWidget {
  const GhSaathiCard({
    super.key,
    required this.data,
    required this.onSelect,
    this.isSelecting = false,
  });

  final SaathiCardData data;
  final VoidCallback onSelect;
  /// True while the selectSaathi callable is in flight for this card
  final bool isSelecting;

  @override
  Widget build(BuildContext context) {
    final meta = VehicleTypeMeta.all[data.vehicleType];

    return Container(
      decoration: BoxDecoration(
        color: CustomerColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: CustomerColors.outlineVariant),
        boxShadow: GhTokens.shadowCardCustomer,
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Vehicle Photo ─────────────────────────────────────────────────
          if (data.vehiclePhotoUrl != null)
            _VehiclePhotoStrip(photoUrl: data.vehiclePhotoUrl!),

          Padding(
            padding: const EdgeInsets.all(GhTokens.spaceMd),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Saathi Name + Verification ──────────────────────────────
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        data.name,
                        style: CustomerTextStyles.titleLg,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const Icon(
                      Icons.verified,
                      size: GhTokens.iconMd,
                      color: CustomerColors.primaryContainer,
                      semanticLabel: 'Verified Saathi',
                    ),
                  ],
                ),
                const SizedBox(height: GhTokens.spaceXs),

                // ── Vehicle Type ───────────────────────────────────────────
                Row(
                  children: [
                    Icon(
                      meta?.icon ?? Icons.local_shipping,
                      size: GhTokens.iconMd,
                      color: CustomerColors.onSurfaceVariant,
                    ),
                    const SizedBox(width: GhTokens.spaceXs),
                    Expanded(
                      child: Text(
                        meta?.englishLabel ?? data.vehicleType.value.toUpperCase(),
                        style: CustomerTextStyles.bodyMd.copyWith(
                          color: CustomerColors.onSurfaceVariant,
                        ),
                      ),
                    ),
                  ],
                ),

                if (data.vehicleRegistrationNumber != null) ...[
                  const SizedBox(height: GhTokens.spaceXs),
                  Text(
                    data.vehicleRegistrationNumber!,
                    style: CustomerTextStyles.labelMd.copyWith(
                      color: CustomerColors.primaryContainer,
                    ),
                  ),
                ],

                const SizedBox(height: GhTokens.spaceMd),

                // ── Rating + Trips ─────────────────────────────────────────
                Row(
                  children: [
                    _RatingBadge(rating: data.ratingAvg),
                    const SizedBox(width: GhTokens.spaceSm),
                    Text(
                      '${data.completedTrips} hauls completed',
                      style: CustomerTextStyles.bodySm,
                    ),
                  ],
                ),

                const SizedBox(height: GhTokens.spaceMd),

                // ── Select CTA ─────────────────────────────────────────────
                SizedBox(
                  width: double.infinity,
                  height: GhTokens.touchTargetMin,
                  child: ElevatedButton(
                    onPressed: isSelecting ? null : onSelect,
                    child: isSelecting
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.5,
                              color: CustomerColors.onPrimary,
                            ),
                          )
                        : const Text('Confirm this Saathi'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _VehiclePhotoStrip extends StatelessWidget {
  const _VehiclePhotoStrip({required this.photoUrl});
  final String photoUrl;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 140,
      width: double.infinity,
      child: CachedNetworkImage(
        imageUrl: photoUrl,
        fit: BoxFit.cover,
        placeholder: (context, url) => Container(
          color: CustomerColors.surfaceContainer,
          child: const Center(
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        ),
        errorWidget: (context, url, error) => Container(
          color: CustomerColors.surfaceContainer,
          child: const Center(
            child: Icon(
              Icons.local_shipping,
              size: 48,
              color: CustomerColors.outlineVariant,
            ),
          ),
        ),
      ),
    );
  }
}

class _RatingBadge extends StatelessWidget {
  const _RatingBadge({required this.rating});
  final double rating;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: GhTokens.spaceSm, vertical: 3),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF3E0),
        borderRadius: BorderRadius.circular(GhTokens.radiusSm),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.star_rounded, size: 14, color: Color(0xFFF59E0B)),
          const SizedBox(width: 3),
          Text(
            rating.toStringAsFixed(1),
            style: CustomerTextStyles.labelMd.copyWith(color: const Color(0xFF92400E)),
          ),
        ],
      ),
    );
  }
}

