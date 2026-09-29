import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_package/shared_package.dart';
import '../data/history_provider.dart';
import 'request_history_detail_screen.dart';

class RequestHistoryScreen extends ConsumerWidget {
  final String customerId;

  const RequestHistoryScreen({super.key, required this.customerId});

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

  Color _getStatusColor(RequestStatus status) {
    switch (status) {
      case RequestStatus.open:
        return Colors.orange;
      case RequestStatus.matched:
        return Colors.blue;
      case RequestStatus.inProgress:
        return Colors.purple;
      case RequestStatus.completed:
        return Colors.green;
      case RequestStatus.cancelled:
        return Colors.red;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final historyAsync = ref.watch(customerHistoryProvider(customerId));

    return historyAsync.when(
      data: (requests) {
        if (requests.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.history, size: 64, color: Colors.grey),
                const SizedBox(height: 16),
                Text(
                  'No requests yet',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                const Text('Your request history will appear here.'),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(customerHistoryProvider(customerId));
          },
          child: ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: requests.length,
            itemBuilder: (context, index) {
              final req = requests[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 12.0),
                child: ListTile(
                  title: Text(req.workType.value.toUpperCase()),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 4),
                      Text('Vehicle: ${req.vehicleTypeRequested.value.toUpperCase()}'),
                      const SizedBox(height: 4),
                      Text(
                        _getStatusLabel(req.status),
                        style: TextStyle(
                          color: _getStatusColor(req.status),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  trailing: const Icon(Icons.chevron_right),
                  isThreeLine: true,
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (_) => RequestHistoryDetailScreen(request: req),
                    ));
                  },
                ),
              );
            },
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, st) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Colors.red),
            const SizedBox(height: 16),
            const Text('Failed to load history'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                ref.invalidate(customerHistoryProvider(customerId));
              },
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}
