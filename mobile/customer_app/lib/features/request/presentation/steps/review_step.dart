import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_package/shared_package.dart';
import '../../../../core/theme/customer_theme.dart';
import '../../../../widgets/gh_request_card.dart';
import '../request_form_controller.dart';

class ReviewStep extends ConsumerWidget {
  const ReviewStep({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(requestFormControllerProvider);
    final controller = ref.read(requestFormControllerProvider.notifier);
    
    final priceRange = controller.getEstimatedPrice();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: ListView(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: CustomerColors.surfaceContainerLowest,
                  borderRadius: BorderRadius.circular(GhTokens.radiusLg),
                  border: Border.all(color: CustomerColors.outlineVariant),
                ),
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.local_shipping, color: CustomerColors.onSurfaceVariant),
                      title: Text('Vehicle', style: CustomerTextStyles.bodySm.copyWith(color: CustomerColors.onSurfaceVariant)),
                      subtitle: Text(state.vehicleType?.value.toUpperCase() ?? '', style: CustomerTextStyles.titleMd),
                    ),
                    const Divider(height: 1),
                    ListTile(
                      leading: const Icon(Icons.work, color: CustomerColors.onSurfaceVariant),
                      title: Text('Work', style: CustomerTextStyles.bodySm.copyWith(color: CustomerColors.onSurfaceVariant)),
                      subtitle: Text(state.workType?.value.toUpperCase() ?? '', style: CustomerTextStyles.titleMd),
                    ),
                    const Divider(height: 1),
                    ListTile(
                      leading: const Icon(Icons.access_time, color: CustomerColors.onSurfaceVariant),
                      title: Text('Timing', style: CustomerTextStyles.bodySm.copyWith(color: CustomerColors.onSurfaceVariant)),
                      subtitle: Text(state.timing?.value.toUpperCase() ?? '', style: CustomerTextStyles.titleMd),
                    ),
                    if (state.timing == RequestTiming.scheduled) ...[
                      const Divider(height: 1),
                      ListTile(
                        leading: const Icon(Icons.event, color: CustomerColors.onSurfaceVariant),
                        title: Text('Scheduled Time', style: CustomerTextStyles.bodySm.copyWith(color: CustomerColors.onSurfaceVariant)),
                        subtitle: Text(state.scheduledAt?.toString() ?? '', style: CustomerTextStyles.titleMd),
                      ),
                    ],
                    const Divider(height: 1),
                    ListTile(
                      leading: const Icon(Icons.timer, color: CustomerColors.onSurfaceVariant),
                      title: Text('Duration', style: CustomerTextStyles.bodySm.copyWith(color: CustomerColors.onSurfaceVariant)),
                      subtitle: Text(state.durationType?.value.toUpperCase() ?? '', style: CustomerTextStyles.titleMd),
                    ),
                    if (state.pickupLocation != null) ...[
                      const Divider(height: 1),
                      ListTile(
                        leading: const Icon(Icons.location_on, color: CustomerColors.onSurfaceVariant),
                        title: Text('Pickup Location', style: CustomerTextStyles.bodySm.copyWith(color: CustomerColors.onSurfaceVariant)),
                        subtitle: Text('${state.pickupLocation!.latitude.toStringAsFixed(3)}, ${state.pickupLocation!.longitude.toStringAsFixed(3)}', style: CustomerTextStyles.titleMd),
                      ),
                    ]
                  ],
                ),
              ),
              const SizedBox(height: GhTokens.spaceXl),
              
              if (priceRange != null) ...[
                GhFareBanner(
                  priceRange: priceRange,
                ),
                const SizedBox(height: GhTokens.spaceMd),
                Text(
                  'Final price is confirmed with the Vahan Saathi after selection.',
                  textAlign: TextAlign.center,
                  style: CustomerTextStyles.bodySm.copyWith(
                    color: CustomerColors.onSurfaceVariant,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ] else ...[
                 Container(
                   padding: const EdgeInsets.all(GhTokens.spaceMd),
                   decoration: BoxDecoration(
                     color: CustomerColors.error.withValues(alpha: 0.1),
                     borderRadius: BorderRadius.circular(GhTokens.radiusMd),
                   ),
                   child: Text(
                    'Estimated price unavailable. Please complete all selections.',
                    textAlign: TextAlign.center,
                    style: CustomerTextStyles.bodyMd.copyWith(color: CustomerColors.error),
                  ),
                 ),
              ]
            ],
          ),
        ),
      ],
    );
  }
}
