import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_package/shared_package.dart';
import 'package:customer_app/features/request/presentation/rating_screen.dart';
import 'package:customer_app/features/request/presentation/waiting_screen.dart';
import '../data/rating_repository.dart';

class RequestHistoryDetailScreen extends ConsumerWidget {
  final RequestModel request;

  const RequestHistoryDetailScreen({super.key, required this.request});

  String _getStatusLabel(RequestStatus status) {
    switch (status) {
      case RequestStatus.open:
        return 'Finding Saathi';
      case RequestStatus.matched:
        return 'Saathi Selected';
      case RequestStatus.inProgress:
        return 'Job In Progress';
      case RequestStatus.completed:
        return 'Completed';
      case RequestStatus.cancelled:
        return 'Cancelled';
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Request Details'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Status', style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 8),
                    Text(
                      _getStatusLabel(request.status),
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const Divider(height: 32),
                    Text('Work Details', style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 8),
                    Text('Work Type: ${request.workType.value.toUpperCase()}'),
                    Text('Vehicle Requested: ${request.vehicleTypeRequested.value.toUpperCase()}'),
                    Text('Duration: ${request.durationType.value}'),
                    const Divider(height: 32),
                    Text('Pricing', style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 8),
                    Text('Estimated Range: ₹${request.estimatedPriceMin} - ₹${request.estimatedPriceMax}'),
                    if (request.finalPrice != null) ...[
                      const SizedBox(height: 8),
                      Text(
                        'Final Price: ₹${request.finalPrice}',
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            _buildActions(context, ref),
          ],
        ),
      ),
    );
  }

  Widget _buildActions(BuildContext context, WidgetRef ref) {
    if (request.status == RequestStatus.open ||
        request.status == RequestStatus.matched ||
        request.status == RequestStatus.inProgress) {
      return ElevatedButton(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (_) => WaitingScreen(requestId: request.id),
          ));
        },
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.all(16.0),
        ),
        child: const Text('View Active Request', style: TextStyle(fontSize: 18)),
      );
    }

    if (request.status == RequestStatus.completed && request.selectedSaathiId != null) {
      return FutureBuilder<bool>(
        future: ref.read(ratingRepositoryProvider).hasRated(request.id, request.customerId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final hasRated = snapshot.data ?? false;

          if (hasRated) {
            return const Card(
              color: Colors.green,
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Center(
                  child: Text(
                    'Already Rated',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                ),
              ),
            );
          } else {
            return ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (_) => RatingScreen(
                    requestId: request.id,
                    saathiId: request.selectedSaathiId!,
                  ),
                )).then((_) {
                  // Ignore for now, might need refresh if returned
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.amber,
                foregroundColor: Colors.black,
                padding: const EdgeInsets.all(16.0),
              ),
              child: const Text('Rate Vahan Saathi', style: TextStyle(fontSize: 18)),
            );
          }
        },
      );
    }

    return const SizedBox.shrink();
  }
}
