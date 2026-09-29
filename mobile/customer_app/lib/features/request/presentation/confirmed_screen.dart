import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:shared_package/shared_package.dart';
import 'package:customer_app/features/request/data/request_repository.dart';
import '../../../core/theme/customer_theme.dart';
import '../../../widgets/gh_buttons.dart';
import '../../../widgets/gh_request_card.dart';
import '../../../widgets/gh_states.dart';
import '../../../widgets/gh_vehicle_type_card.dart';
import '../data/confirmed_repository.dart';
import 'rating_screen.dart';

class ConfirmedScreen extends ConsumerWidget {
  final String requestId;

  const ConfirmedScreen({super.key, required this.requestId});

  Future<void> _launchUrl(String url, BuildContext context) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not open link')),
        );
      }
    }
  }

  Future<void> _markComplete(BuildContext context, WidgetRef ref) async {
    final bool? confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Mark Job Complete?'),
        content: const Text('Are you sure the job is completed?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Confirm', style: TextStyle(color: CustomerColors.primaryContainer)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      try {
        await ref.read(requestRepositoryProvider).markJobComplete(requestId);
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
        }
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dataAsync = ref.watch(confirmedDataProvider(requestId));

    return Scaffold(
      backgroundColor: CustomerColors.surface,
      appBar: AppBar(
        backgroundColor: CustomerColors.surface,
        elevation: 0,
        title: Text('Active Haul', style: CustomerTextStyles.titleLg),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.close, color: CustomerColors.onSurface),
            onPressed: () => Navigator.of(context).popUntil((route) => route.isFirst),
          ),
        ],
      ),
      body: dataAsync.when(
        data: (data) {
          final saathiName = data.saathiUser.name;
          final saathiPhone = data.saathiUser.phone;
          final rating = data.saathiProfile.ratingAvg;
          final vehicleType = data.request.vehicleTypeRequested.value.toUpperCase();
          final regNumber = data.vehicle?.registrationNumber ?? 'Available on arrival';

          final status = data.request.status;
          String headerText = 'Vahan Saathi Confirmed';
          IconData headerIcon = Icons.check_circle;
          Color headerColor = CustomerColors.primaryContainer;
          
          if (status == RequestStatus.inProgress) {
            headerText = 'Haul in Progress';
            headerIcon = Icons.local_shipping;
          } else if (status == RequestStatus.completed) {
            headerText = 'Haul Completed';
            headerIcon = Icons.verified;
          }

          final vehicleMeta = VehicleTypeMeta.all[data.request.vehicleTypeRequested];

          return SingleChildScrollView(
            padding: const EdgeInsets.all(GhTokens.spaceLg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // ── Status Header ──────────────────────────────────────────
                Column(
                  children: [
                    Icon(headerIcon, size: 64, color: headerColor),
                    const SizedBox(height: GhTokens.spaceMd),
                    Text(
                      headerText,
                      style: CustomerTextStyles.headlineSm,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: GhTokens.spaceSm),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.location_on, size: 14, color: CustomerColors.onSurfaceVariant),
                        const SizedBox(width: 4),
                        Text(
                          'Location updated ${GhTokens.locationWarnMinutes} min ago',
                          style: CustomerTextStyles.bodySm.copyWith(color: CustomerColors.onSurfaceVariant),
                        ),
                        const SizedBox(width: 8),
                        GestureDetector(
                          onTap: () {
                             ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Refreshing snapshot...')));
                          },
                          child: const Icon(Icons.refresh, size: 16, color: CustomerColors.primaryContainer),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: GhTokens.spaceXl),
                
                // ── Contact Card ───────────────────────────────────────────
                Container(
                  padding: const EdgeInsets.all(GhTokens.spaceLg),
                  decoration: BoxDecoration(
                    color: CustomerColors.surfaceContainerLowest,
                    borderRadius: BorderRadius.circular(GhTokens.radiusLg),
                    border: Border.all(color: CustomerColors.outlineVariant),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: CustomerColors.surfaceContainer,
                            child: const Icon(Icons.person, color: CustomerColors.onSurfaceVariant),
                          ),
                          const SizedBox(width: GhTokens.spaceMd),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(saathiName, style: CustomerTextStyles.titleLg, maxLines: 1, overflow: TextOverflow.ellipsis),
                                    ),
                                    const Icon(Icons.verified, size: GhTokens.iconSm, color: CustomerColors.primaryContainer),
                                  ],
                                ),
                                Text(
                                  '$rating ⭐️ • ${data.saathiProfile.ratingCount} trips',
                                  style: CustomerTextStyles.bodySm.copyWith(color: CustomerColors.onSurfaceVariant),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const Divider(height: GhTokens.spaceXl),
                      Row(
                        children: [
                          Icon(vehicleMeta?.icon ?? Icons.local_shipping, color: CustomerColors.onSurfaceVariant),
                          const SizedBox(width: GhTokens.spaceSm),
                          Text(vehicleType, style: CustomerTextStyles.bodyMd),
                          const Spacer(),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: GhTokens.spaceSm, vertical: 4),
                            decoration: BoxDecoration(
                              color: CustomerColors.surfaceContainer,
                              borderRadius: BorderRadius.circular(GhTokens.radiusSm),
                            ),
                            child: Text(regNumber, style: CustomerTextStyles.labelMd),
                          ),
                        ],
                      ),
                      const SizedBox(height: GhTokens.spaceXl),
                      Row(
                        children: [
                          Expanded(
                            child: GhSecondaryButton(
                              label: 'Call',
                              icon: Icons.call,
                              onPressed: () => _launchUrl('tel:$saathiPhone', context),
                            ),
                          ),
                          const SizedBox(width: GhTokens.spaceMd),
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () => _launchUrl('https://wa.me/$saathiPhone', context),
                              icon: const Icon(Icons.chat),
                              label: const Text('WhatsApp'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF25D366),
                                foregroundColor: Colors.white,
                                elevation: 0,
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(GhTokens.radiusMd)),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: GhTokens.spaceXl),

                // ── Request Summary ────────────────────────────────────────
                GhRequestCard(
                  request: data.request,
                  onTap: () {},
                ),
                
                const SizedBox(height: GhTokens.spaceXl),
                
                // ── Actions ────────────────────────────────────────────────
                // NOTE: Using status != completed as the button visibility condition
                // because we may not have an explicit in_progress transition built yet.
                // It's safe to show "Complete Job" if it's matched/in_progress.
                if (status != RequestStatus.completed) ...[
                  GhPrimaryButton(
                    label: 'Mark Job Complete',
                    icon: Icons.check_circle,
                    onPressed: () => _markComplete(context, ref),
                  ),
                ],

                if (status == RequestStatus.completed) ...[
                  GhPrimaryButton(
                    label: 'Rate Vahan Saathi',
                    icon: Icons.star,
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (_) => RatingScreen(
                          requestId: data.request.id,
                          saathiId: data.saathiUser.id,
                        ),
                      ));
                    },
                  ),
                ],

                const SizedBox(height: GhTokens.spaceXl),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator(color: CustomerColors.primaryContainer)),
        error: (err, stack) => Center(
          child: Padding(
            padding: const EdgeInsets.all(GhTokens.spaceLg),
            child: GhErrorState(
              message: err.toString(),
              onRetry: () => Navigator.of(context).popUntil((route) => route.isFirst),
            ),
          )
        ),
      ),
    );
  }
}
