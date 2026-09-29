import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_package/shared_package.dart';
import '../../../core/theme/saathi_theme.dart';
import '../../../widgets/saathi_status_badge.dart';
import '../data/vehicle_provider.dart';
import 'availability_controller.dart';
import 'vehicle_registration_screen.dart';

class VehicleManagementScreen extends ConsumerWidget {
  const VehicleManagementScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vehiclesAsync = ref.watch(saathiVehiclesProvider);

    return Scaffold(
      backgroundColor: SaathiColors.surface,
      body: vehiclesAsync.when(
        data: (vehicles) {
          return RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(saathiVehiclesProvider);
            },
            color: SaathiColors.primaryContainer,
            backgroundColor: SaathiColors.surfaceContainerHigh,
            child: ListView(
              padding: const EdgeInsets.all(GhTokens.spaceLg),
              children: [
                // ── Top Header Identity ──────────────────────────────────────────
                Text(
                  'GAAMHAUL • મારું વાહન',
                  style: SaathiTextStyles.labelSm.copyWith(
                    color: SaathiColors.primaryContainer,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: GhTokens.spaceXs),
                Text(
                  'My Garage',
                  style: SaathiTextStyles.headlineXl,
                ),
                const SizedBox(height: GhTokens.spaceMd),

                // ── Info Card ───────────────────────────────────────────────────
                Container(
                  padding: const EdgeInsets.all(GhTokens.spaceMd),
                  decoration: BoxDecoration(
                    color: SaathiColors.primaryContainer.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(GhTokens.radiusSm),
                    border: Border.all(color: SaathiColors.primaryContainer.withValues(alpha: 0.3)),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.info_outline, color: SaathiColors.primaryContainer),
                      const SizedBox(width: GhTokens.spaceMd),
                      Expanded(
                        child: Text(
                          'Manage your registered vehicles here. Only one vehicle can be ON DUTY at a time.',
                          style: SaathiTextStyles.bodySm.copyWith(color: SaathiColors.onSurfaceVariant),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: GhTokens.spaceXl),

                if (vehicles.isEmpty) ...[
                  const SizedBox(height: GhTokens.spaceXl),
                  const Icon(Icons.directions_car, size: 64, color: SaathiColors.onSurfaceVariant),
                  const SizedBox(height: GhTokens.spaceMd),
                  Text(
                    'No Vehicles Registered',
                    style: SaathiTextStyles.headlineLg,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: GhTokens.spaceSm),
                  Text(
                    'You must register a vehicle before you can receive requests.',
                    style: SaathiTextStyles.bodyMd.copyWith(color: SaathiColors.onSurfaceVariant),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: GhTokens.spaceXl),
                ] else ...[
                  for (final vehicle in vehicles) ...[
                    Consumer(
                      builder: (context, ref, _) {
                        final isActive = vehicle.status == VehicleStatus.onDuty;
                        final isLoading = ref.watch(availabilityLoadingProvider)[vehicle.id] ?? false;
                        final availabilityController = ref.read(availabilityControllerProvider(vehicle.id));

                        return Padding(
                          padding: const EdgeInsets.only(bottom: GhTokens.spaceMd),
                          child: SaathiVehicleCard(
                            vehicle: vehicle,
                            isActive: isActive,
                            isLoading: isLoading,
                            onToggleDuty: () {
                              final nextStatus = vehicle.status == VehicleStatus.onDuty ? VehicleStatus.offDuty : VehicleStatus.onDuty;
                              availabilityController.updateStatus(nextStatus, null);
                            },
                            onSwitchTo: isActive ? null : () {
                              availabilityController.updateStatus(VehicleStatus.onDuty, null);
                            },
                          ),
                        );
                      },
                    ),
                  ],
                ],

                Padding(
                  padding: const EdgeInsets.only(top: GhTokens.spaceLg),
                  child: OutlinedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const VehicleRegistrationScreen()),
                      );
                    },
                    icon: const Icon(Icons.add),
                    label: const Text('REGISTER NEW VEHICLE'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      side: const BorderSide(color: SaathiColors.primaryContainer),
                      foregroundColor: SaathiColors.primaryContainer,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
        loading: () => const SaathiLoadingState(message: 'Loading your garage...'),
        error: (e, _) => SaathiErrorState(
          message: e.toString(),
          onRetry: () => ref.invalidate(saathiVehiclesProvider),
        ),
      ),
    );
  }
}
