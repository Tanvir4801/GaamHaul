import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_package/shared_package.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../request_form_controller.dart';
import '../../../../core/theme/customer_theme.dart';

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

  Widget _buildTimeBlock(BuildContext context, String title, String subtitle, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: GhTokens.animFast,
        padding: const EdgeInsets.all(GhTokens.spaceMd),
        decoration: BoxDecoration(
          color: isSelected ? CustomerColors.primaryContainer : CustomerColors.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(GhTokens.radiusMd),
          border: Border.all(
            color: isSelected ? CustomerColors.primaryContainer : CustomerColors.outlineVariant,
            width: 1.0,
          ),
          boxShadow: isSelected ? GhTokens.shadowCardCustomer : null,
        ),
        child: Column(
          children: [
            Text(
              title,
              style: CustomerTextStyles.labelLg.copyWith(
                color: isSelected ? CustomerColors.onPrimary : CustomerColors.onSurface,
              ),
            ),
            const SizedBox(height: GhTokens.spaceXs),
            Text(
              subtitle,
              style: CustomerTextStyles.bodySm.copyWith(
                color: isSelected ? CustomerColors.onPrimary.withValues(alpha: 0.8) : CustomerColors.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(requestFormControllerProvider);
    final controller = ref.read(requestFormControllerProvider.notifier);
    final l10n = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(l10n.stepWhenTitle, style: CustomerTextStyles.headlineLg),
        const SizedBox(height: GhTokens.spaceLg),
        
        Row(
          children: [
            Expanded(
              child: ChoiceChip(
                label: Text('Today', style: CustomerTextStyles.labelMd),
                selected: state.timing == RequestTiming.now,
                onSelected: (selected) {
                  if (selected) controller.setTiming(RequestTiming.now);
                },
                padding: const EdgeInsets.symmetric(vertical: GhTokens.spaceSm),
              ),
            ),
            const SizedBox(width: GhTokens.spaceMd),
            Expanded(
              child: ChoiceChip(
                label: Text('Later', style: CustomerTextStyles.labelMd),
                selected: state.timing == RequestTiming.scheduled,
                onSelected: (selected) {
                  if (selected) _pickDateTime(context, ref);
                },
                padding: const EdgeInsets.symmetric(vertical: GhTokens.spaceSm),
              ),
            ),
          ],
        ),
        const SizedBox(height: GhTokens.spaceXl),
        
        if (state.timing == RequestTiming.scheduled && state.scheduledAt != null) ...[
          Text('Selected Time', style: CustomerTextStyles.titleMd),
          const SizedBox(height: GhTokens.spaceMd),
          Container(
            padding: const EdgeInsets.all(GhTokens.spaceMd),
            decoration: BoxDecoration(
              color: CustomerColors.surfaceContainerLow,
              borderRadius: BorderRadius.circular(GhTokens.radiusMd),
              border: Border.all(color: CustomerColors.outlineVariant),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${state.scheduledAt!.day}/${state.scheduledAt!.month}/${state.scheduledAt!.year} at ${state.scheduledAt!.hour}:${state.scheduledAt!.minute.toString().padLeft(2, '0')}',
                  style: CustomerTextStyles.titleMd,
                ),
                TextButton(
                  onPressed: () => _pickDateTime(context, ref),
                  child: const Text('Change'),
                ),
              ],
            ),
          ),
        ],
        if (state.timing == RequestTiming.now) ...[
          Text('Available Times', style: CustomerTextStyles.titleMd),
          const SizedBox(height: GhTokens.spaceMd),
          Row(
            children: [
              Expanded(
                child: _buildTimeBlock(context, 'Morning', '8 AM - 12 PM', false, () {}),
              ),
              const SizedBox(width: GhTokens.spaceMd),
              Expanded(
                child: _buildTimeBlock(context, 'Afternoon', '12 PM - 4 PM', false, () {}),
              ),
            ],
          ),
          const SizedBox(height: GhTokens.spaceMd),
          Row(
            children: [
              Expanded(
                child: _buildTimeBlock(context, 'Evening', '4 PM - 8 PM', false, () {}),
              ),
              const SizedBox(width: GhTokens.spaceMd),
              const Spacer(),
            ],
          ),
          const SizedBox(height: GhTokens.spaceMd),
          Text(
            'Selecting a time block schedules a vehicle for that approximate window.',
            style: CustomerTextStyles.bodySm,
          ),
        ],
      ],
    );
  }
}
