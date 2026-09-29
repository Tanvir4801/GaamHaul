import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_package/shared_package.dart';
import '../request_form_controller.dart';

class TimingStep extends ConsumerWidget {
  const TimingStep({super.key});

  Future<void> _pickDateTime(BuildContext context, WidgetRef ref) async {
    final now = DateTime.now();
    final date = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: now,
      lastDate: now.add(const Duration(days: 30)),
    );

    if (date != null && context.mounted) {
      final time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(now.add(const Duration(hours: 1))),
      );

      if (time != null) {
        final scheduled = DateTime(date.year, date.month, date.day, time.hour, time.minute);
        ref.read(requestFormControllerProvider.notifier)
           .setTiming(RequestTiming.scheduled, scheduledAt: scheduled);
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(requestFormControllerProvider);
    final controller = ref.read(requestFormControllerProvider.notifier);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text('When do you need it?', style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 16),
        Card(
          color: state.timing == RequestTiming.now ? Theme.of(context).colorScheme.primaryContainer : null,
          child: ListTile(
            title: const Text('Now', style: TextStyle(fontWeight: FontWeight.bold)),
            onTap: () => controller.setTiming(RequestTiming.now),
          ),
        ),
        const SizedBox(height: 8),
        Card(
          color: state.timing == RequestTiming.scheduled ? Theme.of(context).colorScheme.primaryContainer : null,
          child: ListTile(
            title: const Text('Scheduled', style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: state.timing == RequestTiming.scheduled && state.scheduledAt != null
                ? Text(state.scheduledAt!.toString())
                : null,
            onTap: () => _pickDateTime(context, ref),
          ),
        ),
      ],
    );
  }
}
