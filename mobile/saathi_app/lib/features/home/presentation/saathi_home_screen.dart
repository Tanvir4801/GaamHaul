import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_package/shared_package.dart';
import '../../../core/theme/saathi_theme.dart';
import '../../../widgets/saathi_duty_widgets.dart';
import '../../../widgets/saathi_buttons.dart';
import '../../../widgets/saathi_request_widgets.dart';
import '../../vehicle/presentation/availability_controller.dart';
import '../../vehicle/data/vehicle_provider.dart';
import '../../vehicle/presentation/vehicle_registration_screen.dart';
import '../../vehicle/presentation/vehicle_management_screen.dart';
import '../../request/presentation/incoming_request_details_screen.dart';
import '../../request/data/saathi_request_provider.dart';
import '../../profile/presentation/profile_screen.dart';

class SaathiHomeScreen extends ConsumerStatefulWidget {
  final UserModel user;

  const SaathiHomeScreen({super.key, required this.user});

  @override
  ConsumerState<SaathiHomeScreen> createState() => _SaathiHomeScreenState();
}

class _SaathiHomeScreenState extends ConsumerState<SaathiHomeScreen> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _setupInteractedMessage();
  }

  Future<void> _setupInteractedMessage() async {
    RemoteMessage? initialMessage = await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      _handleMessage(initialMessage);
    }
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);
  }

  void _handleMessage(RemoteMessage message) {
    final requestId = message.data['requestId'];
    if (requestId != null) {
      Navigator.of(context).push(MaterialPageRoute(
        builder: (_) => IncomingRequestLoaderScreen(requestId: requestId),
      ));
    }
  }

  Widget _buildCockpit(BuildContext context, List<VehicleModel> vehicles) {
    if (vehicles.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(GhTokens.spaceXl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
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
            SaathiPrimaryButton(
              label: 'Register Vehicle',
              icon: Icons.add,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const VehicleRegistrationScreen()),
                );
              },
            ),
          ],
        ),
      );
    }

    // Use the primary/first vehicle for the cockpit
    final vehicle = vehicles.first;

    return Consumer(
      builder: (context, ref, child) {
        final incomingRequestsAsync = ref.watch(incomingRequestsProvider);
        
        // This is a naive way to toggle duty. 
        // In reality, AvailabilityController manages this per-vehicle.
        final availabilityController = ref.read(availabilityControllerProvider(vehicle.id));

        final isAvailable = vehicle.status == VehicleStatus.onDuty;

        return RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(incomingRequestsProvider);
          },
          color: SaathiColors.primaryContainer,
          backgroundColor: SaathiColors.surfaceContainerHigh,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(
              horizontal: GhTokens.spaceLg,
              vertical: GhTokens.spaceLg,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // ── Top Header Identity ──────────────────────────────────────────
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'GAAMHAUL • વાહન સાથી',
                            style: SaathiTextStyles.labelSm.copyWith(
                              color: SaathiColors.primaryContainer,
                              letterSpacing: 1.2,
                            ),
                          ),
                          const SizedBox(height: GhTokens.spaceXs),
                          Text(
                            'Cockpit',
                            style: SaathiTextStyles.headlineXl,
                          ),
                          const SizedBox(height: GhTokens.spaceSm),
                          // Active vehicle badge
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: SaathiColors.surfaceContainerHigh,
                              borderRadius: BorderRadius.circular(GhTokens.radiusSm),
                              border: Border.all(color: SaathiColors.structuralStroke),
                            ),
                            child: Text(
                              '[ ${vehicle.registrationNumber} ]  [ ${vehicle.type.value.toUpperCase()} ]',
                              style: SaathiTextStyles.labelSm.copyWith(color: SaathiColors.onSurfaceVariant),
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.notifications_none, color: SaathiColors.onSurfaceVariant),
                      onPressed: () {},
                    ),
                  ],
                ),
                const SizedBox(height: GhTokens.spaceLg),

                // ── Location ───────────────────────────────────────────────────
                SaathiLocationStamp(onRefresh: () {}),
                const SizedBox(height: GhTokens.spaceLg),

                // ── Duty Card ──────────────────────────────────────────────────
                SaathiDutyCard(
                  vehicleLabel: vehicle.type.value.toUpperCase(),
                  vehicleStatus: vehicle.status,
                  onToggleDuty: () {
                     final nextStatus = isAvailable ? VehicleStatus.offDuty : VehicleStatus.onDuty;
                     availabilityController.updateStatus(nextStatus, null);
                  },
                ),
                const SizedBox(height: GhTokens.spaceLg),

                // ── Activity Data ──────────────────────────────────────────────
                const SaathiActivityStats(),
                const SizedBox(height: GhTokens.spaceLg),

                // ── Incoming Requests Feed ─────────────────────────────────────
                Text('Incoming Requests', style: SaathiTextStyles.headlineLg),
                const SizedBox(height: GhTokens.spaceMd),

                if (!isAvailable)
                  Container(
                    padding: const EdgeInsets.all(GhTokens.spaceLg),
                    decoration: BoxDecoration(
                      color: SaathiColors.surfaceContainer,
                      borderRadius: BorderRadius.circular(GhTokens.radiusLg),
                      border: Border.all(color: SaathiColors.surfaceContainerHigh),
                    ),
                    child: Column(
                      children: [
                        const Icon(Icons.power_off, size: 48, color: SaathiColors.onSurfaceVariant),
                        const SizedBox(height: GhTokens.spaceMd),
                        Text(
                          'You are offline',
                          style: SaathiTextStyles.headlineMd,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: GhTokens.spaceSm),
                        Text(
                          'Go ON DUTY to receive new requests in your area.',
                          style: SaathiTextStyles.bodySm.copyWith(color: SaathiColors.onSurfaceVariant),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  )
                else
                  incomingRequestsAsync.when(
                    data: (requests) {
                      if (requests.isEmpty) {
                        return Container(
                          padding: const EdgeInsets.all(GhTokens.spaceLg),
                          decoration: BoxDecoration(
                            color: SaathiColors.surfaceContainerLowest,
                            borderRadius: BorderRadius.circular(GhTokens.radiusLg),
                          ),
                          child: Column(
                            children: [
                              const Icon(Icons.radar, size: 48, color: SaathiColors.primaryContainer),
                              const SizedBox(height: GhTokens.spaceMd),
                              Text(
                                'Scanning for jobs...',
                                style: SaathiTextStyles.headlineMd,
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: GhTokens.spaceSm),
                              Text(
                                'No requests nearby at the moment.',
                                style: SaathiTextStyles.bodySm.copyWith(color: SaathiColors.onSurfaceVariant),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        );
                      }

                      return ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: requests.length,
                        separatorBuilder: (context, _) => const SizedBox(height: GhTokens.spaceMd),
                        itemBuilder: (context, index) {
                          final request = requests[index];
                          // Distance is not reliably available in MVP
                          double? distanceKm;
                          
                          return SaathiRequestCard(
                            request: request,
                            distanceKm: distanceKm,
                            onViewRequest: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (_) => IncomingRequestLoaderScreen(requestId: request.id),
                              ));
                            },
                          );
                        },
                      );
                    },
                    loading: () => const Center(child: CircularProgressIndicator(color: SaathiColors.primaryContainer)),
                    error: (e, _) => Text('Error loading requests: $e', style: SaathiTextStyles.bodySm.copyWith(color: SaathiColors.error)),
                  ),
                
                const SizedBox(height: GhTokens.spaceXl),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final vehiclesAsync = ref.watch(saathiVehiclesProvider);

    return Scaffold(
      backgroundColor: SaathiColors.surface,
      body: SafeArea(
        child: IndexedStack(
          index: _selectedIndex,
          children: [
            vehiclesAsync.when(
              data: (vehicles) => _buildCockpit(context, vehicles),
              loading: () => const Center(child: CircularProgressIndicator(color: SaathiColors.primaryContainer)),
              error: (e, _) => Center(child: Text('Error: $e')),
            ),
            const VehicleManagementScreen(),
            ProfileScreen(user: widget.user),
          ],
        ),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.dashboard_outlined),
            selectedIcon: Icon(Icons.dashboard, color: SaathiColors.primaryContainer),
            label: 'Cockpit',
          ),
          NavigationDestination(
            icon: Icon(Icons.directions_car_outlined),
            selectedIcon: Icon(Icons.directions_car, color: SaathiColors.primaryContainer),
            label: 'Garage',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person, color: SaathiColors.primaryContainer),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
