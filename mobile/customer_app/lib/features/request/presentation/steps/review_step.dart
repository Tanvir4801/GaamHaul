import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_package/shared_package.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../../core/theme/customer_theme.dart';
import '../request_form_controller.dart';
import '../widgets/booking_summary_card.dart';

class ReviewStep extends ConsumerWidget {
  const ReviewStep({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(requestFormControllerProvider);
    final controller = ref.read(requestFormControllerProvider.notifier);
    final l10n = AppLocalizations.of(context)!;
    
    final priceRange = controller.getEstimatedPrice();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(l10n.stepReviewTitle, style: CustomerTextStyles.headlineLg),
        const SizedBox(height: GhTokens.spaceLg),
        
        Expanded(
          child: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.all(GhTokens.spaceLg),
              decoration: BoxDecoration(
                color: CustomerColors.surfaceContainerLowest,
                borderRadius: BorderRadius.circular(GhTokens.radiusXl),
                border: Border.all(color: CustomerColors.outlineVariant),
                boxShadow: GhTokens.shadowCardCustomer,
              ),
              child: Column(
                children: [
                  BookingSummaryCard(
                    title: 'VEHICLE',
                    value: state.vehicleType?.name.toUpperCase() ?? '',
                    onEdit: () => controller.jumpToStep(0),
                  ),
                  BookingSummaryCard(
                    title: 'WORK',
                    value: state.workType?.name.toUpperCase() ?? '',
                    onEdit: () => controller.jumpToStep(1),
                  ),
                  BookingSummaryCard(
                    title: 'PICKUP',
                    value: state.pickupLocation != null 
                        ? '${state.pickupLocation!.latitude.toStringAsFixed(3)}, ${state.pickupLocation!.longitude.toStringAsFixed(3)}'
                        : 'Location',
                    onEdit: () => controller.jumpToStep(2),
                  ),
                  BookingSummaryCard(
                    title: 'WHEN',
                    value: state.timing == RequestTiming.now ? 'Today' : 'Scheduled',
                    subtitle: state.scheduledAt != null ? '${state.scheduledAt!.day}/${state.scheduledAt!.month}/${state.scheduledAt!.year} at ${state.scheduledAt!.hour}:${state.scheduledAt!.minute.toString().padLeft(2, '0')}' : null,
                    onEdit: () => controller.jumpToStep(3),
                  ),
                  BookingSummaryCard(
                    title: 'DURATION',
                    value: state.durationType?.name.toUpperCase() ?? '',
                    onEdit: () => controller.jumpToStep(4),
                  ),
                  
                  const SizedBox(height: GhTokens.spaceMd),
                  if (priceRange != null) ...[
                    Container(
                      padding: const EdgeInsets.all(GhTokens.spaceMd),
                      decoration: BoxDecoration(
                        color: CustomerColors.primaryContainer.withValues(alpha: 0.05),
                        borderRadius: BorderRadius.circular(GhTokens.radiusMd),
                      ),
                      child: Column(
                        children: [
                          Text(l10n.estimatedFare, style: CustomerTextStyles.labelMd.copyWith(color: CustomerColors.onSurfaceVariant)),
                          const SizedBox(height: GhTokens.spaceXs),
                          Text(
                            '₹${priceRange.min} – ₹${priceRange.max}',
                            style: CustomerTextStyles.headlineLg.copyWith(color: CustomerColors.primaryContainer),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: GhTokens.spaceMd),
                    Text(
                      l10n.fareDisclaimer,
                      textAlign: TextAlign.center,
                      style: CustomerTextStyles.bodySm.copyWith(
                        color: CustomerColors.onSurfaceVariant,
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
          ),
        ),
      ],
    );
  }
}
