import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:my_time/common/extensions/build_context_extension.dart';
import 'package:my_time/common/extensions/date_time_extension.dart';
import 'package:my_time/common/extensions/duration_extension.dart';
import 'package:my_time/domain/group_domain/models/enums/wokrplace.dart';
import 'package:my_time/features/9_timer/presentation/widgets/responsive_time_data.dart';
import 'package:my_time/foundation/config/theme/tokens/color_tokens.dart';
import 'package:my_time/foundation/config/theme/tokens/space_tokens.dart';
import 'package:my_time/foundation/config/theme/tokens/text_style_tokens.dart';
import 'package:my_time/foundation/core/widgets/spaced_column.dart';
import 'package:my_time/foundation/core/widgets/spaced_row.dart';
import 'package:my_time/foundation/core/widgets/wizard/wizard_review_step/review_card.dart';
import 'package:my_time/foundation/core/widgets/wizard/wizard_review_step/show_review_value.dart';
import 'package:my_time/foundation/core/widgets/wizard/wizard_review_step/wizard_review_step.dart';
import 'package:my_time/foundation/core/widgets/wizard/wizard_review_step/wizard_review_step_controller.dart';
import 'package:my_time/foundation/core/widgets/wizard/wizard_review_step/wizard_review_step_event_listener.dart';

/// Review Step in the add project wizard.
class ReviewStep extends ConsumerWidget {
  /// Constructor for the ReviewStep widget.
  const ReviewStep({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return WizardReviewStep(
      stepsLength: 6,
      builder: (controller) => WizardReviewStepEventListener(
        controller: controller,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: SpaceTokens.medium,
              vertical: SpaceTokens.medium,
            ),
            child: Visibility(
              child: SpacedColumn(
                spacing: SpaceTokens.medium,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const _DateReview(),
                  _TimeDataWidget(controller: controller),
                  const _WorkplaceReview(),
                  const _DescriptionReview(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _TimeDataWidget extends StatefulWidget {
  const _TimeDataWidget({required this.controller});

  final WizardReviewStepController controller;

  @override
  State<_TimeDataWidget> createState() => _TimeDataWidgetState();
}

class _TimeDataWidgetState extends State<_TimeDataWidget> {
  bool hasTimeError = false;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ResponsiveTimeData(
          startTimeWidget: Expanded(
            child: _TimeReview(
              label: context.loc.entryStartTimeLabel,
              stepToJumpTo: 1,
            ),
          ),
          endTimeWidget: Expanded(
            child: _TimeReview(
              label: context.loc.entryEndTimeLabel,
              stepToJumpTo: 2,
            ),
          ),
          breakTimeWidget: Expanded(
            child: _TimeReview(
              label: context.loc.entryBreakTimeLabel,
              stepToJumpTo: 3,
            ),
          ),
          totalTimeWidget: Expanded(
            child: _TotalTimeReview(
              label: context.loc.entryTotalTimeLabel,
              steps: const [1, 2, 3],
              controller: widget.controller,
              validityChanged: (isValid) {
                setState(() {
                  hasTimeError = !isValid;
                });
              },
            ),
          ),
        ),
        Visibility(
          visible: hasTimeError,
          child: Padding(
            padding: const EdgeInsets.only(top: SpaceTokens.small),
            child: SpacedRow(
              spacing: SpaceTokens.medium,
              children: [
                const Icon(
                  Icons.close,
                  color: ThemelessColorTokens.red,
                ),
                Text(
                  context.loc.entryTotalTimeErrorMessage,
                  style: TextStyleTokens.bodyMedium(null)
                      .copyWith(color: ThemelessColorTokens.red),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _DateReview extends StatelessWidget {
  const _DateReview();

  @override
  Widget build(BuildContext context) {
    return ReviewDataCard<DateTime?>(
      label: context.loc.entryDateLabel,
      stepToJumpTo: 0,
      evaluateVisibility: (data) {
        if (data == null) return false;
        return true;
      },
      builder: (data) => [
        ReviewDataValue(
          label: data?.toFormattedDateString() ?? '',
        ),
      ],
    );
  }
}

class _TimeReview extends StatelessWidget {
  const _TimeReview({required this.label, required this.stepToJumpTo});
  final String label;
  final int stepToJumpTo;
  @override
  Widget build(BuildContext context) {
    return ReviewDataCard<Duration?>(
      label: label,
      stepToJumpTo: stepToJumpTo,
      evaluateVisibility: (data) {
        if (data == null) return false;
        return true;
      },
      builder: (data) => [
        ReviewDataValue(
          label: data?.toFormattedString() ?? '',
        ),
      ],
    );
  }
}

class _TotalTimeReview extends StatefulWidget {
  const _TotalTimeReview({
    required this.label,
    required this.steps,
    required this.controller,
    required this.validityChanged,
  });
  final String label;
  final List<int> steps;
  final WizardReviewStepController controller;
  final void Function(bool isValid) validityChanged;

  @override
  State<_TotalTimeReview> createState() => _TotalTimeReviewState();
}

class _TotalTimeReviewState extends State<_TotalTimeReview> {
  Duration _total = Duration.zero;
  void evaluateTotalTime(
    Duration total,
  ) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_total == total) return;
      setState(() {
        _total = total;
      });
      final isValid = total.inMinutes > 0;
      if (isValid) {
        widget.controller.enableFinish();
      } else {
        widget.controller.disableFinish();
      }
      widget.validityChanged.call(isValid);
    });
  }

  @override
  Widget build(BuildContext context) {
    return AccumulatedDataCard(
      label: widget.label,
      steps: widget.steps,
      evaluateVisibility: (data) {
        if (data.isEmpty) return false;
        if (data[1] == null || data[2] == null || data[3] == null) return false;
        return true;
      },
      builder: (data) {
        final start = data[1] as Duration? ?? Duration.zero;
        final end = data[2] as Duration? ?? Duration.zero;
        final breakTime = data[3] as Duration? ?? Duration.zero;

        final total = end - start - breakTime;
        evaluateTotalTime(total);

        return [
          ReviewDataValue(
            label: total.toFormattedString(),
          ),
        ];
      },
    );
  }
}

class _WorkplaceReview extends StatelessWidget {
  const _WorkplaceReview();

  @override
  Widget build(BuildContext context) {
    return ReviewDataCard<Workplace?>(
      label: context.loc.reviewStepWorkplaceLabel,
      stepToJumpTo: 4,
      evaluateVisibility: (data) {
        if (data == null) return false;
        return true;
      },
      builder: (data) => [
        ReviewDataValue(
          label: data?.label(context) ?? '',
        ),
      ],
    );
  }
}

class _DescriptionReview extends StatelessWidget {
  const _DescriptionReview();

  @override
  Widget build(BuildContext context) {
    return ReviewDataCard<String?>(
      label: context.loc.descriptionFieldLabel,
      stepToJumpTo: 5,
      evaluateVisibility: (data) {
        if (data == null) return false;
        return true;
      },
      builder: (data) => [
        ReviewDataValue(
          label: data ?? '',
        ),
      ],
    );
  }
}
