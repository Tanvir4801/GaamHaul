import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_package/shared_package.dart';
import 'request_repository.dart';

final customerHistoryProvider = FutureProvider.family<List<RequestModel>, String>((ref, customerId) async {
  final repo = ref.watch(requestRepositoryProvider);
  return repo.getCustomerHistory(customerId);
});
