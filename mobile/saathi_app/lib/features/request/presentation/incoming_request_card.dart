import 'package:flutter/material.dart';
import 'package:shared_package/shared_package.dart';
import 'incoming_request_details_screen.dart';

class IncomingRequestCard extends StatelessWidget {
  final RequestModel request;

  const IncomingRequestCard({super.key, required this.request});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => IncomingRequestDetailsScreen(request: request),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    request.workType.value.toUpperCase(),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.green,
                    ),
                  ),
                  Text(
                    '₹${request.estimatedPriceMin.toInt()} - ₹${request.estimatedPriceMax.toInt()}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.local_shipping, size: 16, color: Colors.grey),
                  const SizedBox(width: 8),
                  Text('Requested: ${request.vehicleTypeRequested.value.toUpperCase()}'),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.access_time, size: 16, color: Colors.grey),
                  const SizedBox(width: 8),
                  Text(request.timing == RequestTiming.now ? 'Right Now' : 'Scheduled'),
                ],
              ),
              const SizedBox(height: 8),
              const Row(
                children: [
                  Icon(Icons.location_on, size: 16, color: Colors.blue),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text('Pickup Location (Lat/Lng mapped)'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
