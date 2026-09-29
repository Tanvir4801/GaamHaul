import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_package/shared_package.dart';
import '../../../core/theme/saathi_theme.dart';
import '../../../widgets/saathi_buttons.dart';
import '../../../widgets/saathi_duty_widgets.dart';
// Removed saathi_status_badge.dart
import '../data/saathi_request_provider.dart';
import '../data/saathi_request_repository.dart';
import '../../vehicle/data/vehicle_provider.dart';

class IncomingRequestLoaderScreen extends ConsumerWidget {
  final String requestId;

  const IncomingRequestLoaderScreen({super.key, required this.requestId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final liveRequestAsync = ref.watch(saathiRequestProvider(requestId));
    return liveRequestAsync.when(
      data: (request) {
        if (request == null) {
          return Scaffold(
            backgroundColor: SaathiColors.surface,
            appBar: AppBar(backgroundColor: SaathiColors.surface, title: const Text('Error')), 
            body: Center(child: Text('Request not found', style: SaathiTextStyles.headlineLg)),
          );
        }
        return IncomingRequestDetailsScreen(request: request);
      },
      loading: () => const Scaffold(
        backgroundColor: SaathiColors.surface,
        body: Center(child: CircularProgressIndicator(color: SaathiColors.primaryContainer)),
      ),
      error: (e, _) => Scaffold(
        backgroundColor: SaathiColors.surface,
        appBar: AppBar(title: const Text('Error')), 
        body: Center(child: Text('Error: $e')),
      ),
    );
  }
}

class IncomingRequestDetailsScreen extends ConsumerStatefulWidget {
  final RequestModel request;

  const IncomingRequestDetailsScreen({super.key, required this.request});

  @override
  ConsumerState<IncomingRequestDetailsScreen> createState() => _IncomingRequestDetailsScreenState();
}

class _IncomingRequestDetailsScreenState extends ConsumerState<IncomingRequestDetailsScreen> {
  bool _isSubmitting = false;

  Future<void> _onExpressInterest(String vehicleId) async {
    setState(() {
      _isSubmitting = true;
    });

    try {
      await ref.read(saathiRequestRepositoryProvider).markInterested(
        requestId: widget.request.id,
        vehicleId: vehicleId,
      );
      if (mounted) {
         ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Interest expressed successfully! Waiting for customer selection.'),
            backgroundColor: SaathiColors.primaryContainer,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to express interest: $e'),
            backgroundColor: SaathiColors.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final liveRequestAsync = ref.watch(saathiRequestProvider(widget.request.id));
    final currentRequest = liveRequestAsync.value ?? widget.request;
    final vehiclesAsync = ref.watch(saathiVehiclesProvider);

    return Scaffold(
      backgroundColor: SaathiColors.surface,
      appBar: AppBar(
        backgroundColor: SaathiColors.surface,
        elevation: 0,
        title: Text('Job Details', style: SaathiTextStyles.headlineLg),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: SaathiColors.onSurfaceVariant),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(GhTokens.spaceLg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ── Request Status / Meta ──────────────────────────────────────
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: currentRequest.status == RequestStatus.open 
                      ? SaathiColors.primaryContainer 
                      : SaathiColors.onSurfaceVariant,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    currentRequest.status.value.toUpperCase(),
                    style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                ),
                const Spacer(),
                SaathiLocationStamp(
                  locationName: 'Lat: ${currentRequest.pickupLocation.latitude.toStringAsFixed(2)}, Lng: ${currentRequest.pickupLocation.longitude.toStringAsFixed(2)}',
                  onRefresh: () {},
                ),
              ],
            ),
            const SizedBox(height: GhTokens.spaceLg),

            // ── Price Banner ───────────────────────────────────────────────
            Container(
              padding: const EdgeInsets.symmetric(vertical: GhTokens.spaceLg, horizontal: GhTokens.spaceMd),
              decoration: BoxDecoration(
                color: SaathiColors.surfaceContainerHigh,
                borderRadius: BorderRadius.circular(GhTokens.radiusLg),
                border: Border.all(color: SaathiColors.primaryContainer.withValues(alpha: 0.3)),
              ),
              child: Column(
                children: [
                  Text('Estimated Fare', style: SaathiTextStyles.bodySm.copyWith(color: SaathiColors.onSurfaceVariant)),
                  const SizedBox(height: GhTokens.spaceXs),
                  Text(
                    '₹${currentRequest.estimatedPriceMin.toInt()} - ₹${currentRequest.estimatedPriceMax.toInt()}',
                    style: SaathiTextStyles.headlineXl.copyWith(color: SaathiColors.primaryContainer),
                  ),
                ],
              ),
            ),
            const SizedBox(height: GhTokens.spaceXl),

            // ── Requirements Card ──────────────────────────────────────────
            Container(
              padding: const EdgeInsets.all(GhTokens.spaceLg),
              decoration: BoxDecoration(
                color: SaathiColors.surfaceContainerLowest,
                borderRadius: BorderRadius.circular(GhTokens.radiusLg),
                border: Border.all(color: SaathiColors.surfaceContainerHigh),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(currentRequest.workType.value.toUpperCase(), style: SaathiTextStyles.headlineLg),
                  const Divider(color: SaathiColors.surfaceContainerHigh, height: GhTokens.spaceXl),
                  _buildDetailRow(Icons.work, 'Work Type', currentRequest.workType.value.toUpperCase()),
                  _buildDetailRow(Icons.local_shipping, 'Vehicle Needed', currentRequest.vehicleTypeRequested.value.toUpperCase()),
                  _buildDetailRow(Icons.timelapse, 'Duration', currentRequest.durationType.value.toUpperCase()),
                  _buildDetailRow(Icons.access_time, 'Timing', currentRequest.timing == RequestTiming.now ? 'Right Now' : 'Scheduled'),
                  if (currentRequest.scheduledAt != null)
                    _buildDetailRow(Icons.calendar_today, 'Date/Time', currentRequest.scheduledAt!.toDate().toLocal().toString()),
                ],
              ),
            ),
            const SizedBox(height: GhTokens.spaceLg),

            // ── Location Card ──────────────────────────────────────────────
            Container(
              padding: const EdgeInsets.all(GhTokens.spaceLg),
              decoration: BoxDecoration(
                color: SaathiColors.surfaceContainerLowest,
                borderRadius: BorderRadius.circular(GhTokens.radiusLg),
                border: Border.all(color: SaathiColors.surfaceContainerHigh),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Location', style: SaathiTextStyles.headlineLg),
                  const Divider(color: SaathiColors.surfaceContainerHigh, height: GhTokens.spaceXl),
                  _buildDetailRow(Icons.location_on, 'Pickup', 'Lat: ${currentRequest.pickupLocation.latitude.toStringAsFixed(4)}\nLng: ${currentRequest.pickupLocation.longitude.toStringAsFixed(4)}'),
                  if (currentRequest.destinationLocation != null)
                    _buildDetailRow(Icons.flag, 'Dropoff', 'Lat: ${currentRequest.destinationLocation!.latitude.toStringAsFixed(4)}\nLng: ${currentRequest.destinationLocation!.longitude.toStringAsFixed(4)}'),
                ],
              ),
            ),
            const SizedBox(height: GhTokens.spaceXl),

            // ── Action Area ────────────────────────────────────────────────
            vehiclesAsync.maybeWhen(
              data: (vehicles) {
                if (vehicles.isEmpty) return const SizedBox.shrink();
                
                try {
                  final matchedVehicle = vehicles.firstWhere(
                    (v) => currentRequest.shortlistedVehicleIds.contains(v.id),
                    orElse: () => vehicles.first,
                  );

                  return _buildActionArea(currentRequest, matchedVehicle.id);
                } catch (_) {
                  return const SizedBox.shrink();
                }
              },
              orElse: () => const Center(child: CircularProgressIndicator(color: SaathiColors.primaryContainer)),
            ),
            const SizedBox(height: GhTokens.spaceXl),
          ],
        ),
      ),
    );
  }

  Widget _buildActionArea(RequestModel request, String vehicleId) {
    if (request.status != RequestStatus.open) {
      return Container(
        padding: const EdgeInsets.all(GhTokens.spaceLg),
        decoration: BoxDecoration(
          color: SaathiColors.surfaceContainerHigh,
          borderRadius: BorderRadius.circular(GhTokens.radiusMd),
        ),
        child: Column(
          children: [
            const Icon(Icons.info_outline, color: SaathiColors.onSurfaceVariant),
            const SizedBox(height: GhTokens.spaceSm),
            Text(
              'This request is ${request.status.value.toUpperCase()}.',
              style: SaathiTextStyles.headlineMd.copyWith(color: SaathiColors.onSurfaceVariant),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              'You can no longer express interest.',
              style: SaathiTextStyles.bodySm.copyWith(color: SaathiColors.onSurfaceVariant),
            ),
          ],
        ),
      );
    }

    return SaathiPrimaryButton(
      label: 'EXPRESS INTEREST',
      icon: Icons.check,
      onPressed: () => _onExpressInterest(vehicleId),
      isLoading: _isSubmitting,
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: GhTokens.spaceSm),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: GhTokens.iconMd, color: SaathiColors.onSurfaceVariant),
          const SizedBox(width: GhTokens.spaceMd),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: SaathiTextStyles.labelMd.copyWith(color: SaathiColors.onSurfaceVariant)),
                const SizedBox(height: 2),
                Text(value, style: SaathiTextStyles.headlineMd),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
