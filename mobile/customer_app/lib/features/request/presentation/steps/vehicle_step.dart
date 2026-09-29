import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_package/shared_package.dart';
import '../request_form_controller.dart';

class VehicleStep extends ConsumerWidget {
  const VehicleStep({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(requestFormControllerProvider);
    final controller = ref.read(requestFormControllerProvider.notifier);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text('Select Vehicle', style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 16),
        Expanded(
          child: ListView.builder(
            itemCount: VehicleType.values.length,
            itemBuilder: (context, index) {
              final type = VehicleType.values[index];
              final isSelected = state.vehicleType == type;

              return Card(
                color: isSelected ? Theme.of(context).colorScheme.primaryContainer : null,
                child: ListTile(
                  title: Text(
                    type.value.toUpperCase(),
                    style: TextStyle(
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                  trailing: isSelected ? const Icon(Icons.check_circle) : null,
                  onTap: () => controller.setVehicle(type),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
