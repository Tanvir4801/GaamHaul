import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_package/shared_package.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../core/theme/customer_theme.dart';
import '../../../widgets/gh_buttons.dart';
import '../../../widgets/gh_request_card.dart';
import '../../../widgets/gh_states.dart';
import '../../../widgets/gh_vehicle_type_card.dart';

import '../../request/data/history_provider.dart';
import '../../request/presentation/request_flow_screen.dart';
import '../../request/presentation/request_form_controller.dart';
import '../../request/presentation/request_history_detail_screen.dart';
import '../../request/presentation/request_history_screen.dart';
import '../../request/presentation/waiting_screen.dart';

class CustomerHomeScreen extends ConsumerStatefulWidget {
  final UserModel user;

  const CustomerHomeScreen({super.key, required this.user});

  @override
  ConsumerState<CustomerHomeScreen> createState() => _CustomerHomeScreenState();
}

class _CustomerHomeScreenState extends ConsumerState<CustomerHomeScreen> {
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
        builder: (_) => WaitingScreen(requestId: requestId),
      ));
    }
  }

  void _startRequestFlow(BuildContext context, WidgetRef ref, {VehicleType? vehicleType}) {
    ref.read(requestFormControllerProvider.notifier).resetFlow();
    // If we wanted to pre-select a vehicle, we would do it here. 
    // For now, the flow starts at step 1.
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => const RequestFlowScreen(),
    ));
  }

  Widget _buildHomeTab(BuildContext context, WidgetRef ref) {
    final historyAsync = ref.watch(customerHistoryProvider(widget.user.id));

    return RefreshIndicator(
      onRefresh: () async {
        ref.invalidate(customerHistoryProvider(widget.user.id));
      },
      color: CustomerColors.primaryContainer,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(
          horizontal: GhTokens.spaceLg,
          vertical: GhTokens.spaceLg,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ── Location ───────────────────────────────────────────────────
            Row(
              children: [
                const Icon(Icons.location_on, color: CustomerColors.primaryContainer, size: GhTokens.iconMd),
                const SizedBox(width: GhTokens.spaceXs),
                Text(
                  'Current Location', // A placeholder until actual user location is persisted
                  style: CustomerTextStyles.labelMd.copyWith(color: CustomerColors.onSurfaceVariant),
                ),
                const Icon(Icons.keyboard_arrow_down, color: CustomerColors.onSurfaceVariant, size: GhTokens.iconSm),
              ],
            ),
            const SizedBox(height: GhTokens.spaceLg),

            // ── Greeting ───────────────────────────────────────────────────
            Text(
              'Good morning,\n${widget.user.name.split(' ').first}',
              style: CustomerTextStyles.headlineLg,
            ),
            const SizedBox(height: GhTokens.spaceXl),

            // ── Primary Hire Vehicle CTA ───────────────────────────────────
            GhHighlightButton(
              label: AppLocalizations.of(context)!.bookVehicleCta,
              icon: Icons.local_shipping,
              onPressed: () => _startRequestFlow(context, ref),
            ),
            const SizedBox(height: GhTokens.spaceXl),

            // ── Recent/Active Request ──────────────────────────────────────
            historyAsync.when(
              data: (requests) {
                // Find the most recent active request, or just the most recent one
                if (requests.isEmpty) return const SizedBox.shrink();

                final activeRequest = requests.firstWhere(
                  (r) => r.status != RequestStatus.completed && r.status != RequestStatus.cancelled,
                  orElse: () => requests.first,
                );

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GhSectionHeader(
                      title: 'Active Haul',
                      trailing: 'See All',
                      onTrailingTap: () {
                        setState(() {
                          _selectedIndex = 1;
                        });
                      },
                    ),
                    const SizedBox(height: GhTokens.spaceMd),
                    GhRequestCard(
                      request: activeRequest,
                      onTap: () {
                        if (activeRequest.status == RequestStatus.open || activeRequest.status == RequestStatus.matched) {
                           Navigator.of(context).push(MaterialPageRoute(
                            builder: (_) => WaitingScreen(requestId: activeRequest.id),
                          ));
                        } else {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (_) => RequestHistoryDetailScreen(request: activeRequest),
                          ));
                        }
                      },
                    ),
                    const SizedBox(height: GhTokens.spaceXl),
                  ],
                );
              },
              loading: () => const Center(child: CircularProgressIndicator(color: CustomerColors.primaryContainer)),
              error: (e, _) => GhErrorState(
                message: e.toString(),
                onRetry: () => ref.invalidate(customerHistoryProvider(widget.user.id)),
              ),
            ),

            // ── Vehicle Categories ─────────────────────────────────────────
            const GhSectionHeader(title: 'Available Vehicles'),
            const SizedBox(height: GhTokens.spaceMd),
            
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: VehicleType.values.length,
              separatorBuilder: (context, _) => const SizedBox(height: GhTokens.spaceSm),
              itemBuilder: (context, index) {
                final type = VehicleType.values[index];
                return GhVehicleTypeCard(
                  vehicleType: type,
                  isSelected: false,
                  onTap: () => _startRequestFlow(context, ref, vehicleType: type),
                );
              },
            ),
            
            const SizedBox(height: GhTokens.spaceXl),
            
            // ── Trust/Context Information ──────────────────────────────────
            Container(
              padding: const EdgeInsets.all(GhTokens.spaceMd),
              decoration: BoxDecoration(
                color: CustomerColors.primaryContainer.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(GhTokens.radiusLg),
              ),
              child: Row(
                children: [
                  const Icon(Icons.security, color: CustomerColors.primaryContainer, size: 32),
                  const SizedBox(width: GhTokens.spaceMd),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Trusted Vahan Saathis', style: CustomerTextStyles.titleMd),
                        const SizedBox(height: GhTokens.spaceXs),
                        Text(
                          'All our drivers are verified from your local community.',
                          style: CustomerTextStyles.bodySm.copyWith(color: CustomerColors.onSurfaceVariant),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: GhTokens.spaceXl),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomerColors.surface,
      appBar: _selectedIndex == 1 
        ? AppBar(
            backgroundColor: CustomerColors.surface,
            elevation: 0,
            title: Text('Request History', style: CustomerTextStyles.titleLg),
          ) 
        : null,
      body: SafeArea(
        child: IndexedStack(
          index: _selectedIndex,
          children: [
            _buildHomeTab(context, ref),
            RequestHistoryScreen(customerId: widget.user.id),
          ],
        ),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        backgroundColor: CustomerColors.surfaceContainerLowest,
        indicatorColor: CustomerColors.primaryContainer.withValues(alpha: 0.2),
        onDestinationSelected: (index) {
          if (index == 2) {
             ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Profile coming in later phase')),
              );
             return;
          }
          setState(() {
            _selectedIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home, color: CustomerColors.primaryContainer),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.receipt_long_outlined),
            selectedIcon: Icon(Icons.receipt_long, color: CustomerColors.primaryContainer),
            label: 'History',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person, color: CustomerColors.primaryContainer),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
