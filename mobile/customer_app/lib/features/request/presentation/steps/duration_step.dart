import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_package/shared_package.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../request_form_controller.dart';
import '../widgets/duration_fare_card.dart';
import '../../../../core/theme/customer_theme.dart';

class DurationStep extends ConsumerStatefulWidget {
  const DurationStep({super.key});

  @override
  ConsumerState<DurationStep> createState() => _DurationStepState();
}

class _DurationStepState extends ConsumerState<DurationStep> {
  final _customController = TextEditingController();

  @override
  void dispose() {
    _customController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(requestFormControllerProvider);
    final controller = ref.read(requestFormControllerProvider.notifier);
    final l10n = AppLocalizations.of(context)!;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(l10n.stepDurationTitle, style: CustomerTextStyles.headlineLg),
          const SizedBox(height: GhTokens.spaceLg),
          ...DurationType.values.map((type) {
            final isSelected = state.durationType == type;
            
            PriceRange? estimate;
            if (state.vehicleType != null) {
              estimate = RateCardCalculator.calculateEstimatedPrice(
                vehicleType: state.vehicleType!,
                durationType: type,
              );
            }

            return DurationFareCard(
              durationType: type,
              estimatedPrice: estimate,
              isSelected: isSelected,
              onTap: () {
                controller.setDuration(type, customText: type == DurationType.custom ? _customController.text : null);
              },
              child: (isSelected && type == DurationType.custom) ? TextField(
                controller: _customController,
                style: CustomerTextStyles.bodyMd.copyWith(color: CustomerColors.onPrimary),
                decoration: InputDecoration(
                  labelText: 'Describe duration (e.g. 3 days)',
                  labelStyle: CustomerTextStyles.bodyMd.copyWith(color: CustomerColors.onPrimary.withValues(alpha: 0.8)),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(GhTokens.radiusSm),
                    borderSide: BorderSide(color: CustomerColors.onPrimary.withValues(alpha: 0.5)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(GhTokens.radiusSm),
                    borderSide: const BorderSide(color: CustomerColors.onPrimary),
                  ),
                ),
                onChanged: (val) {
                  controller.setDuration(type, customText: val);
                },
              ) : null,
            );
          }),
        ],
      ),
    );
  }
}
