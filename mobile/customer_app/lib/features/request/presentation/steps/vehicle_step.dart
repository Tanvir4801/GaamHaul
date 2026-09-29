import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_package/shared_package.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../request_form_controller.dart';
import '../widgets/vehicle_selection_card.dart';
import '../../../../core/theme/customer_theme.dart';

class VehicleStep extends ConsumerWidget {
  const VehicleStep({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(requestFormControllerProvider);
    final controller = ref.read(requestFormControllerProvider.notifier);
    final l10n = AppLocalizations.of(context)!;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(l10n.stepVehicleTitle, style: CustomerTextStyles.headlineLg),
          const SizedBox(height: GhTokens.spaceXs),
          Text(
            l10n.stepVehicleSub,
            style: CustomerTextStyles.bodyLg.copyWith(color: CustomerColors.onSurfaceVariant),
          ),
          const SizedBox(height: GhTokens.spaceXl),
          ...VehicleType.values.map((type) {
            final isSelected = state.vehicleType == type;
            return VehicleSelectionCard(
              vehicleType: type,
              isSelected: isSelected,
              onTap: () => controller.setVehicle(type),
            );
          }),
        ],
      ),
    );
  }
}
