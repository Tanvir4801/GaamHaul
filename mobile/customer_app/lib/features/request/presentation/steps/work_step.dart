import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_package/shared_package.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../request_form_controller.dart';
import '../widgets/work_type_chip.dart';
import '../../../../core/theme/customer_theme.dart';

class WorkStep extends ConsumerWidget {
  const WorkStep({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(requestFormControllerProvider);
    final controller = ref.read(requestFormControllerProvider.notifier);
    final l10n = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(l10n.stepWorkTitle, style: CustomerTextStyles.headlineLg),
        const SizedBox(height: GhTokens.spaceXs),
        Text(
          l10n.stepWorkSub,
          style: CustomerTextStyles.bodyLg.copyWith(color: CustomerColors.onSurfaceVariant),
        ),
        const SizedBox(height: GhTokens.spaceXl),
        Expanded(
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: GhTokens.spaceMd,
              mainAxisSpacing: GhTokens.spaceMd,
              childAspectRatio: 1.2,
            ),
            itemCount: WorkType.values.length,
            itemBuilder: (context, index) {
              final type = WorkType.values[index];
              final isSelected = state.workType == type;

              return WorkTypeChip(
                workType: type,
                isSelected: isSelected,
                onTap: () => controller.setWorkType(type),
              );
            },
          ),
        ),
      ],
    );
  }
}
