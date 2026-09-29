import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_package/shared_package.dart';
import '../../../core/theme/customer_theme.dart';
import '../../../widgets/gh_buttons.dart';
import '../../../widgets/gh_saathi_card.dart';
import '../../../widgets/gh_states.dart';
import '../data/request_repository.dart';
import '../data/saathi_card_provider.dart';
import 'confirmed_screen.dart';

class WaitingScreen extends ConsumerStatefulWidget {
  final String requestId;

  const WaitingScreen({super.key, required this.requestId});

  @override
  ConsumerState<WaitingScreen> createState() => _WaitingScreenState();
}

class _WaitingScreenState extends ConsumerState<WaitingScreen> {
  String? _selectingSaathiId;

  Future<void> _cancelRequest(BuildContext context, WidgetRef ref) async {
    final bool? confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Cancel this request?'),
        content: const Text('Your request will no longer be available for matching.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Keep Request'),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Cancel Request', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      try {
        await ref.read(requestRepositoryProvider).cancelRequest(widget.requestId);
      } catch (e) {
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
      }
    }
  }

  Future<void> _selectSaathi(BuildContext context, WidgetRef ref, InterestedSaathiModel saathi) async {
    setState(() {
      _selectingSaathiId = saathi.saathiId;
    });

    try {
      await ref.read(requestRepositoryProvider).selectSaathi(
        requestId: widget.requestId,
        saathiId: saathi.saathiId,
        vehicleId: saathi.vehicleId,
      );
    } catch (e) {
      if (mounted) {
        if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to select Saathi: $e')));
      }
    } finally {
      if (mounted) {
        setState(() {
          _selectingSaathiId = null;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final requestAsync = ref.watch(requestStreamProvider(widget.requestId));

    return requestAsync.when(
      data: (request) {
        if (request == null) {
          return const Scaffold(
            body: Center(child: Text('Request not found.')),
          );
        }

        if (request.status == RequestStatus.cancelled) {
          return Scaffold(
            appBar: AppBar(title: const Text('Cancelled'), automaticallyImplyLeading: false),
            body: GhErrorState(
              message: 'This request is no longer active.',
              onRetry: () => Navigator.of(context).pop(),
            ),
          );
        }

        if ((request.status == RequestStatus.matched || 
             request.status == RequestStatus.inProgress || 
             request.status == RequestStatus.completed) && 
             request.selectedSaathiId != null) {
          return ConfirmedScreen(requestId: request.id);
        }

        final hasInterested = request.interestedSaathis.isNotEmpty;

        return Scaffold(
          backgroundColor: CustomerColors.surface,
          appBar: AppBar(
            backgroundColor: CustomerColors.surface,
            elevation: 0,
            title: Text('Finding a Vehicle', style: CustomerTextStyles.titleLg),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: CustomerColors.onSurface),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: GhTokens.spaceLg, vertical: GhTokens.spaceMd),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (!hasInterested) ...[
                  const Expanded(
                    child: GhEmptyState(
                      icon: Icons.radar,
                      heading: 'Scanning for Saathis',
                      message: 'Your request is broadcasted to nearby vehicle owners. Please wait while they express interest.',
                    ),
                  ),
                ] else ...[
                  Text(
                    'Interested Saathis',
                    style: CustomerTextStyles.headlineSm,
                  ),
                  const SizedBox(height: GhTokens.spaceMd),
                  Expanded(
                    child: ListView.separated(
                      itemCount: request.interestedSaathis.length,
                      separatorBuilder: (context, index) => const SizedBox(height: GhTokens.spaceMd),
                      itemBuilder: (context, index) {
                        final saathiInterest = request.interestedSaathis[index];
                        final cardDataAsync = ref.watch(saathiCardDataProvider(saathiInterest));

                        return cardDataAsync.when(
                          data: (cardData) => GhSaathiCard(
                            data: cardData,
                            isSelecting: _selectingSaathiId == cardData.saathiId,
                            onSelect: () => _selectSaathi(context, ref, saathiInterest),
                          ),
                          loading: () => const Center(child: Padding(
                            padding: EdgeInsets.all(GhTokens.spaceMd),
                            child: CircularProgressIndicator(),
                          )),
                          error: (e, _) => Text('Error loading saathi: $e'),
                        );
                      },
                    ),
                  ),
                ],
                
                if (request.status == RequestStatus.open) ...[
                  const SizedBox(height: GhTokens.spaceLg),
                  GhDestructiveButton(
                    label: 'Cancel Request',
                    icon: Icons.close,
                    onPressed: () => _cancelRequest(context, ref),
                  ),
                  const SizedBox(height: GhTokens.spaceMd),
                ]
              ],
            ),
          ),
        );
      },
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator(color: CustomerColors.primaryContainer)),
      ),
      error: (err, stack) => Scaffold(
        body: GhErrorState(
          message: err.toString(),
          onRetry: () => Navigator.of(context).pop(),
        ),
      ),
    );
  }
}
