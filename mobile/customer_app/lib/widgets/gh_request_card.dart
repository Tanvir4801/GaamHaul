import 'package:flutter/material.dart';
import 'package:shared_package/shared_package.dart';
import '../core/theme/customer_theme.dart';
import 'gh_status_chip.dart';
import 'gh_vehicle_type_card.dart';

// ─────────────────────────────────────────────────────────────────────────────
// GhRequestCard — Request history + active status list item
// References: Customer_home.png (recent job), RequestHistory
// ─────────────────────────────────────────────────────────────────────────────

/// Card for a single request in the history list or home screen's recent job.
/// Visual state changes by [request.status].
/// [onTap] navigates to the request detail screen.
class GhRequestCard extends StatelessWidget {
  const GhRequestCard({
    super.key,
    required this.request,
    required this.onTap,
  });

  final RequestModel request;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final meta = VehicleTypeMeta.all[request.vehicleTypeRequested];
    final isActive = request.status == RequestStatus.open ||
        request.status == RequestStatus.matched ||
        request.status == RequestStatus.inProgress;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: CustomerColors.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isActive
                ? CustomerColors.secondary.withValues(alpha: 0.20) // Cerulean
                : CustomerColors.outlineVariant,
            width: isActive ? 2.0 : 1.0,
          ),
          boxShadow: isActive ? GhTokens.shadowCardCustomer : null,
        ),
        padding: const EdgeInsets.all(GhTokens.spaceMd),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Vehicle icon badge
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: CustomerColors.surfaceContainer,
                borderRadius: BorderRadius.circular(GhTokens.radiusMd),
              ),
              child: Icon(
                meta?.icon ?? Icons.local_shipping,
                size: GhTokens.iconLg,
                color: CustomerColors.primaryContainer,
              ),
            ),
            const SizedBox(width: GhTokens.spaceMd),

            // Request info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Status + Vehicle
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      GhStatusChip(status: request.status),
                      const Spacer(),
                      Text(
                        _formatDate(request.createdAt.toDate()),
                        style: CustomerTextStyles.bodySm,
                      ),
                    ],
                  ),
                  const SizedBox(height: GhTokens.spaceSm),

                  Text(
                    meta?.englishLabel ?? request.vehicleTypeRequested.value.toUpperCase(),
                    style: CustomerTextStyles.titleMd,
                  ),

                  const SizedBox(height: GhTokens.spaceXs),

                  Text(
                    '${request.workType.value.toUpperCase()} · ${request.durationType.value.toUpperCase()}',
                    style: CustomerTextStyles.bodySm,
                  ),

                  const SizedBox(height: GhTokens.spaceXs),

                  // Price
                  if (request.finalPrice != null)
                    Text(
                      '₹${request.finalPrice!.toInt()} (final)',
                      style: CustomerTextStyles.labelMd.copyWith(
                        color: CustomerColors.primaryContainer,
                      ),
                    )
                  else
                    Text(
                      '₹${request.estimatedPriceMin.toInt()}–₹${request.estimatedPriceMax.toInt()} est.',
                      style: CustomerTextStyles.labelMd.copyWith(
                        color: CustomerColors.onSurfaceVariant,
                      ),
                    ),
                ],
              ),
            ),

            const SizedBox(width: GhTokens.spaceSm),
            Icon(
              Icons.chevron_right,
              size: GhTokens.iconLg,
              color: CustomerColors.onSurfaceVariant,
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime dt) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    return '${dt.day} ${months[dt.month - 1]}';
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// GhFareBanner — Estimated fare display in request flow
// References: RequestFlow.png (dashed fare card)
// ─────────────────────────────────────────────────────────────────────────────

/// Navy-accented fare estimate banner.
/// Shown in request review step. Only displayed when [priceRange] is non-null.
class GhFareBanner extends StatelessWidget {
  const GhFareBanner({
    super.key,
    required this.priceRange,
    this.note,
  });

  final PriceRange priceRange;
  /// Optional disclaimer note below the fare (e.g., "direct settlement")
  final String? note;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(GhTokens.spaceMd),
      decoration: BoxDecoration(
        color: CustomerColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: CustomerColors.outlineVariant,
          width: 1.0,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'ESTIMATED FARE',
            style: CustomerTextStyles.labelSm.copyWith(
              color: CustomerColors.primaryContainer,
            ),
          ),
          const SizedBox(height: GhTokens.spaceXs),
          Text(
            '₹${priceRange.min.toInt()} – ₹${priceRange.max.toInt()}',
            style: CustomerTextStyles.headlineMd.copyWith(
              color: CustomerColors.primaryContainer,
              fontWeight: FontWeight.w700,
            ),
          ),
          if (note != null) ...[
            const SizedBox(height: GhTokens.spaceXs),
            Text(
              note!,
              style: CustomerTextStyles.bodySm.copyWith(
                color: CustomerColors.onSurfaceVariant,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
