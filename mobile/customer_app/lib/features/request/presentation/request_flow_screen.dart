import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_package/shared_package.dart';
import '../../../core/theme/customer_theme.dart';
import '../../../widgets/gh_buttons.dart';
import 'request_form_controller.dart';
import 'steps/vehicle_step.dart';
import 'steps/work_step.dart';
import 'steps/timing_step.dart';
import 'steps/duration_step.dart';
import 'steps/location_step.dart';
import 'steps/review_step.dart';
import 'waiting_screen.dart';

class RequestFlowScreen extends ConsumerWidget {
  const RequestFlowScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(requestFormControllerProvider);
    final controller = ref.read(requestFormControllerProvider.notifier);

    // Navigate to waiting screen if submitted
    if (state.isSuccess && state.createdRequestId != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) => WaitingScreen(requestId: state.createdRequestId!),
          ),
        );
      });
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final steps = [
      const VehicleStep(),
      const WorkStep(),
      const TimingStep(),
      const DurationStep(),
      const LocationStep(),
      const ReviewStep(),
    ];
    
    final stepTitles = [
      'Select Vehicle',
      'Select Work Type',
      'Timing',
      'Duration',
      'Location',
      'Review & Submit',
    ];

    return Scaffold(
      backgroundColor: CustomerColors.surface,
      appBar: AppBar(
        backgroundColor: CustomerColors.surface,
        elevation: 0,
        title: Text(stepTitles[state.currentStep], style: CustomerTextStyles.titleLg),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: CustomerColors.onSurface),
          onPressed: () {
            if (state.currentStep > 0) {
              controller.previousStep();
            } else {
              controller.resetFlow();
              Navigator.of(context).pop();
            }
          },
        ),
      ),
      body: Stack(
        children: [
          Column(
            children: [
              // Stepper Progress Bar
              LinearProgressIndicator(
                value: (state.currentStep + 1) / steps.length,
                backgroundColor: CustomerColors.surfaceContainer,
                color: CustomerColors.primaryContainer,
                minHeight: 4,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(GhTokens.spaceLg),
                  child: Column(
                    children: [
                      Expanded(
                        child: steps[state.currentStep],
                      ),
                      if (state.errorMessage != null) ...[
                        const SizedBox(height: GhTokens.spaceMd),
                        Container(
                          padding: const EdgeInsets.all(GhTokens.spaceSm),
                          decoration: BoxDecoration(
                            color: CustomerColors.error.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(GhTokens.radiusSm),
                          ),
                          child: Text(
                            state.errorMessage!,
                            style: CustomerTextStyles.bodySm.copyWith(color: CustomerColors.error),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                      const SizedBox(height: GhTokens.spaceLg),
                      GhHighlightButton(
                        label: state.currentStep == steps.length - 1 ? 'SUBMIT REQUEST' : 'CONTINUE',
                        onPressed: state.isSubmitting 
                            ? null 
                            : () {
                                if (state.currentStep == steps.length - 1) {
                                  controller.submitRequest();
                                } else {
                                  controller.nextStep();
                                }
                              },
                        isLoading: state.isSubmitting,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          if (state.isSubmitting)
            Container(
              color: Colors.black45,
              child: const Center(
                child: CircularProgressIndicator(color: CustomerColors.primaryContainer),
              ),
            ),
        ],
      ),
    );
  }
}
