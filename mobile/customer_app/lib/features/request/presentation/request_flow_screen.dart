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
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class RequestFlowScreen extends ConsumerStatefulWidget {
  const RequestFlowScreen({super.key});

  @override
  ConsumerState<RequestFlowScreen> createState() => _RequestFlowScreenState();
}

class _RequestFlowScreenState extends ConsumerState<RequestFlowScreen> {
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    final initialState = ref.read(requestFormControllerProvider);
    _pageController = PageController(initialPage: initialState.currentStep);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(requestFormControllerProvider);
    final controller = ref.read(requestFormControllerProvider.notifier);
    final l10n = AppLocalizations.of(context)!;

    ref.listen(requestFormControllerProvider.select((state) => state.currentStep), (previous, next) {
      if (previous != next && _pageController.hasClients) {
        _pageController.animateToPage(
          next,
          duration: GhTokens.animSlow,
          curve: GhTokens.curveEaseInOut,
        );
      }
    });

    ref.listen(requestFormControllerProvider.select((state) => state.isSuccess), (previous, next) {
      if (next && state.createdRequestId != null) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) => WaitingScreen(requestId: state.createdRequestId!),
          ),
        );
      }
    });

    final steps = [
      const VehicleStep(),
      const WorkStep(),
      const LocationStep(),
      const TimingStep(),
      const DurationStep(),
      const ReviewStep(),
    ];

    return Scaffold(
      backgroundColor: CustomerColors.surface,
      appBar: AppBar(
        backgroundColor: CustomerColors.surface,
        elevation: 0,
        title: Text(
          '0${state.currentStep + 1} / 0${steps.length}', 
          style: CustomerTextStyles.labelLg.copyWith(color: CustomerColors.onSurfaceVariant)
        ),
        centerTitle: true,
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
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                LinearProgressIndicator(
                  value: (state.currentStep + 1) / steps.length,
                  backgroundColor: CustomerColors.surfaceContainer,
                  color: CustomerColors.primaryContainer,
                  minHeight: 2,
                ),
                Expanded(
                  child: PageView(
                    controller: _pageController,
                    physics: const NeverScrollableScrollPhysics(),
                    children: steps,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(GhTokens.spaceLg),
                  child: Column(
                    children: [
                      if (state.errorMessage != null) ...[
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
                        const SizedBox(height: GhTokens.spaceMd),
                      ],
                      GhHighlightButton(
                        label: state.currentStep == steps.length - 1 ? l10n.actionFindVehicle : l10n.actionContinue,
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
      ),
    );
  }
}
