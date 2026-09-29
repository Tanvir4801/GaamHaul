import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_package/shared_package.dart';
import '../request_form_controller.dart';

class DurationStep extends ConsumerStatefulWidget {
  const DurationStep({super.key});

  @override
  ConsumerState<DurationStep> createState() => _DurationStepState();
}

class _DurationStepState extends ConsumerState<DurationStep> {
  final _customController = TextEditingController();

  @override
  void dispose() {
    _customController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(requestFormControllerProvider);
    final controller = ref.read(requestFormControllerProvider.notifier);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text('For how long?', style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 16),
        Expanded(
          child: ListView.builder(
            itemCount: DurationType.values.length,
            itemBuilder: (context, index) {
              final type = DurationType.values[index];
              final isSelected = state.durationType == type;

              return Card(
                color: isSelected ? Theme.of(context).colorScheme.primaryContainer : null,
                child: Column(
                  children: [
                    ListTile(
                      title: Text(
                        type.value.toUpperCase(),
                        style: TextStyle(fontWeight: isSelected ? FontWeight.bold : FontWeight.normal),
                      ),
                      onTap: () {
                        controller.setDuration(type, customText: type == DurationType.custom ? _customController.text : null);
                      },
                    ),
                    if (isSelected && type == DurationType.custom)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                        child: TextField(
                          controller: _customController,
                          decoration: const InputDecoration(
                            labelText: 'Describe duration (e.g. 3 days)',
                            border: OutlineInputBorder(),
                          ),
                          onChanged: (val) {
                            controller.setDuration(type, customText: val);
                          },
                        ),
                      )
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
