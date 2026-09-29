import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_package/shared_package.dart';
import '../../../core/theme/saathi_theme.dart';
import '../../../widgets/saathi_buttons.dart';
import '../../../widgets/saathi_request_widgets.dart';
import '../data/saathi_request_provider.dart';
import '../data/saathi_request_repository.dart';

class SelectedJobScreen extends ConsumerStatefulWidget {
  final String requestId;

  const SelectedJobScreen({super.key, required this.requestId});

  @override
  ConsumerState<SelectedJobScreen> createState() => _SelectedJobScreenState();
}

class _SelectedJobScreenState extends ConsumerState<SelectedJobScreen> {
  bool _isCompleting = false;

  Future<void> _completeHaul(BuildContext context) async {
    final bool? confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: SaathiColors.surface,
        title: Text('Complete Haul?', style: SaathiTextStyles.headlineLg),
        content: Text('Are you sure you want to mark this haul as completed?', style: SaathiTextStyles.bodyMd),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text('Cancel', style: SaathiTextStyles.labelMd.copyWith(color: SaathiColors.onSurfaceVariant)),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text('Complete', style: SaathiTextStyles.labelMd.copyWith(color: SaathiColors.secondary)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      setState(() => _isCompleting = true);
      try {
        await ref.read(saathiRequestRepositoryProvider).markJobComplete(widget.requestId);
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Haul Completed!'), backgroundColor: SaathiColors.secondary),
        );
      } catch (e) {
        if (mounted) {
          if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: $e'), backgroundColor: SaathiColors.error),
          );
        }
      } finally {
        if (mounted) {
          setState(() => _isCompleting = false);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final requestAsync = ref.watch(saathiRequestProvider(widget.requestId));

    return requestAsync.when(
      data: (request) {
        if (request == null) {
          return Scaffold(
            backgroundColor: SaathiColors.surface,
            body: Center(child: Text('Job not found', style: SaathiTextStyles.headlineLg)),
          );
        }

        final isCompleted = request.status == RequestStatus.completed;

        return Scaffold(
          backgroundColor: SaathiColors.surface,
          appBar: AppBar(
            backgroundColor: SaathiColors.surface,
            elevation: 0,
            title: Text('Active Haul', style: SaathiTextStyles.headlineLg),
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
                // ── Status Banner ──────────────────────────────────────────
                Container(
                  padding: const EdgeInsets.all(GhTokens.spaceLg),
                  decoration: BoxDecoration(
                    color: isCompleted ? SaathiColors.secondary.withValues(alpha: 0.1) : SaathiColors.surfaceContainerLowest,
                    borderRadius: BorderRadius.circular(GhTokens.radiusLg),
                    border: Border.all(color: isCompleted ? SaathiColors.secondary : SaathiColors.surfaceContainerHigh),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        isCompleted ? Icons.check_circle : Icons.navigation, 
                        color: isCompleted ? SaathiColors.secondary : SaathiColors.primary,
                        size: 32,
                      ),
                      const SizedBox(width: GhTokens.spaceMd),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              isCompleted ? 'Haul Completed' : 'En Route to Pickup',
                              style: SaathiTextStyles.headlineLg.copyWith(color: isCompleted ? SaathiColors.secondary : SaathiColors.onSurface),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'Request #${request.id.substring(0, 8)}',
                              style: SaathiTextStyles.bodySm.copyWith(color: SaathiColors.onSurfaceVariant),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: GhTokens.spaceXl),

                // ── Milestones ─────────────────────────────────────────────
                Text('Trip Status · Milestones', style: SaathiTextStyles.headlineLg),
                const SizedBox(height: GhTokens.spaceLg),
                
                SaathiMilestoneRow(
                  label: 'Vahan Saathi Confirmed',
                  sublabel: 'You were selected for this job',
                  status: MilestoneStatus.completed,
                ),
                const Padding(
                  padding: EdgeInsets.only(left: 11.0, top: 4, bottom: 4),
                  child: SizedBox(
                    height: 20,
                    child: VerticalDivider(color: SaathiColors.surfaceContainerHigh, thickness: 2),
                  ),
                ),
                SaathiMilestoneRow(
                  label: 'In Progress',
                  sublabel: 'Heading to pickup / Active duty',
                  status: isCompleted ? MilestoneStatus.completed : MilestoneStatus.active,
                ),
                const Padding(
                  padding: EdgeInsets.only(left: 11.0, top: 4, bottom: 4),
                  child: SizedBox(
                    height: 20,
                    child: VerticalDivider(color: SaathiColors.surfaceContainerHigh, thickness: 2),
                  ),
                ),
                SaathiMilestoneRow(
                  label: 'Haul Completed',
                  sublabel: 'Payment settled & customer rated',
                  status: isCompleted ? MilestoneStatus.completed : MilestoneStatus.pending,
                ),
                
                const SizedBox(height: GhTokens.spaceXl),
                const Divider(color: SaathiColors.surfaceContainerHigh),
                const SizedBox(height: GhTokens.spaceXl),

                // ── Trip Details ───────────────────────────────────────────
                Text('Trip Details', style: SaathiTextStyles.headlineLg),
                const SizedBox(height: GhTokens.spaceLg),
                
                _buildDetailRow(Icons.work, 'Work Type', request.workType.value.toUpperCase()),
                _buildDetailRow(Icons.local_shipping, 'Vehicle', request.vehicleTypeRequested.value.toUpperCase()),
                _buildDetailRow(Icons.location_on, 'Pickup', 'Lat: ${request.pickupLocation.latitude.toStringAsFixed(4)}, Lng: ${request.pickupLocation.longitude.toStringAsFixed(4)}'),
                if (request.destinationLocation != null)
                  _buildDetailRow(Icons.flag, 'Dropoff', 'Lat: ${request.destinationLocation!.latitude.toStringAsFixed(4)}, Lng: ${request.destinationLocation!.longitude.toStringAsFixed(4)}'),
                
                const SizedBox(height: GhTokens.spaceMd),
                Container(
                  padding: const EdgeInsets.all(GhTokens.spaceMd),
                  decoration: BoxDecoration(
                    color: SaathiColors.surfaceContainerHigh,
                    borderRadius: BorderRadius.circular(GhTokens.radiusMd),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Final Fare', style: SaathiTextStyles.headlineMd.copyWith(color: SaathiColors.onSurfaceVariant)),
                      Text(
                        '₹${request.finalPrice?.toInt() ?? request.estimatedPriceMax.toInt()}',
                        style: SaathiTextStyles.headlineLg.copyWith(color: SaathiColors.primaryContainer),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 48),

                if (!isCompleted)
                  SaathiSuccessButton(
                    label: 'COMPLETE HAUL',
                    icon: Icons.check_circle,
                    onPressed: () => _completeHaul(context),
                    isLoading: _isCompleting,
                  ),
                  
                const SizedBox(height: GhTokens.spaceXl),
              ],
            ),
          ),
        );
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

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: GhTokens.spaceLg),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: GhTokens.iconLg, color: SaathiColors.onSurfaceVariant),
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
