import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_package/shared_package.dart';
import 'saathi_request_repository.dart';
import '../../vehicle/data/vehicle_provider.dart';

final incomingRequestsProvider = StreamProvider<List<RequestModel>>((ref) async* {
  final vehicles = await ref.watch(saathiVehiclesProvider.future);
  final vehicleIds = vehicles.map((v) => v.id).toList();

  if (vehicleIds.isEmpty) {
    yield [];
    return;
  }

  final repository = ref.watch(saathiRequestRepositoryProvider);
  yield* repository.watchIncomingRequests(vehicleIds);
});

final saathiRequestProvider = StreamProvider.family<RequestModel?, String>((ref, requestId) {
  final repository = ref.watch(saathiRequestRepositoryProvider);
  return repository.watchRequest(requestId);
});
