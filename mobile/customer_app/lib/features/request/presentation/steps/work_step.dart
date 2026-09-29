import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_package/shared_package.dart';
import '../request_form_controller.dart';

class WorkStep extends ConsumerWidget {
  const WorkStep({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(requestFormControllerProvider);
    final controller = ref.read(requestFormControllerProvider.notifier);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text('What kind of work?', style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 16),
        Wrap(
          spacing: 8.0,
          runSpacing: 8.0,
          children: WorkType.values.map((type) {
            final isSelected = state.workType == type;
            return ChoiceChip(
              label: Text(type.value.toUpperCase()),
              selected: isSelected,
              onSelected: (selected) {
                if (selected) controller.setWorkType(type);
              },
            );
          }).toList(),
        ),
      ],
    );
  }
}
