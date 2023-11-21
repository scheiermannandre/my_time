import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:my_time/common/extensions/build_context_extension.dart';
import 'package:my_time/config/theme/mighty_theme.dart';
import 'package:my_time/config/theme/space_tokens.dart';
import 'package:my_time/core/util/extentions/widget_ref_extension.dart';
import 'package:my_time/core/widgets/wizard/wizard_review_step/wizard_review_step.dart';
import 'package:my_time/core/widgets/wizard/wizard_review_step/wizard_review_step_event_listener.dart';
import 'package:my_time/core/widgets/wizard/wizard_review_step/wizard_review_step_wrapper.dart';
import 'package:my_time/features/7_groups_overview/domain/entities/enums/currency.dart';
import 'package:my_time/features/7_groups_overview/domain/entities/enums/payment_interval.dart';
import 'package:my_time/features/7_groups_overview/domain/entities/enums/payment_status.dart';
import 'package:my_time/features/7_groups_overview/domain/entities/enums/reference_period.dart';
import 'package:my_time/features/7_groups_overview/domain/entities/enums/wokrplace.dart';
import 'package:my_time/features/7_groups_overview/domain/entities/group_entity.dart';
import 'package:my_time/features/7_groups_overview/domain/entities/project_money_management_entity.dart';
import 'package:my_time/features/7_groups_overview/domain/entities/project_time_management_entity.dart';
import 'package:my_time/features/7_groups_overview/domain/entities/vacation_entity.dart';
import 'package:my_time/features/7_groups_overview/presentation/state_management/review_step_controller.dart';

/// Review Step in the add project wizard.
class ReviewStep extends ConsumerWidget {
  /// Constructor for the ReviewStep widget.
  const ReviewStep({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.watchStateProvider(
      context,
      mightyThemeControllerProvider,
      mightyThemeControllerProvider.notifier,
    );

    final reviewStep = ref.watchAndListenStateProviderError(
      context,
      reviewStepControllerProvider,
      reviewStepControllerProvider.notifier,
    );

    return WizardReviewStep(
      stepsLength: 8,
      builder: (controller) => WizardReviewStepEventListener(
        onFinishEvent: (event) async {
          final success = await reviewStep.controller.addProject(event.data);

          if (success && context.mounted) {
            context.pop();
          }
        },
        controller: controller,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: SpaceTokens.medium,
              vertical: SpaceTokens.medium,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _GroupReview(themeController: theme.controller),
                _ProjectNameReview(themeController: theme.controller),
                _SickDaysReview(themeController: theme.controller),
                _PublicHolidaysReview(themeController: theme.controller),
                _VacationInfoReview(themeController: theme.controller),
                _TimeManagementReview(themeController: theme.controller),
                _MoneyManagementReview(themeController: theme.controller),
                _WorkplaceReview(themeController: theme.controller),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _GroupReview extends StatelessWidget {
  const _GroupReview({required this.themeController});
  final MightyThemeController themeController;

  @override
  Widget build(BuildContext context) {
    return _MightyLabeledWidgets(
      label: context.loc.reviewStepGroupLabel,
      children: [
        WizardReviewStepWrapper<GroupEntity?>(
          stepToJumpTo: 0,
          builder: (data) => _ShowValue(
            label: data?.name ?? '',
            data: '',
            labelStyle: themeController.alternateBody,
          ),
        ),
      ],
    );
  }
}

class _ProjectNameReview extends StatelessWidget {
  const _ProjectNameReview({required this.themeController});
  final MightyThemeController themeController;

  @override
  Widget build(BuildContext context) {
    return _MightyLabeledWidgets(
      label: context.loc.reviewStepProjectNameLabel,
      children: [
        WizardReviewStepWrapper<String?>(
          stepToJumpTo: 1,
          builder: (data) => _ShowValue(
            label: data ?? '',
            data: '',
            labelStyle: themeController.alternateBody,
          ),
        ),
      ],
    );
  }
}

class _SickDaysReview extends StatelessWidget {
  const _SickDaysReview({required this.themeController});
  final MightyThemeController themeController;

  @override
  Widget build(BuildContext context) {
    return WizardReviewStepWrapper<PaymentStatus?>(
      stepToJumpTo: 2,
      builder: (data) {
        return Visibility(
          visible: data != null,
          child: _MightyLabeledWidgets(
            label: context.loc.reviewStepSickDaysPaymentLabel,
            children: [
              _ShowValue(
                label: data?.label(context) ?? '',
                data: '',
                labelStyle: themeController.alternateBody,
              ),
            ],
          ),
        );
      },
    );
  }
}

class _PublicHolidaysReview extends StatelessWidget {
  const _PublicHolidaysReview({required this.themeController});

  final MightyThemeController themeController;

  @override
  Widget build(BuildContext context) {
    return WizardReviewStepWrapper<PaymentStatus?>(
      stepToJumpTo: 3,
      builder: (data) {
        return Visibility(
          visible: data != null,
          child: _MightyLabeledWidgets(
            label: context.loc.reviewStepPublicHolidaysPaymentLabel,
            children: [
              _ShowValue(
                label: data?.label(context) ?? '',
                data: '',
                labelStyle: themeController.alternateBody,
              ),
            ],
          ),
        );
      },
    );
  }
}

class _VacationInfoReview extends StatelessWidget {
  const _VacationInfoReview({required this.themeController});
  final MightyThemeController themeController;

  @override
  Widget build(BuildContext context) {
    final labelStyle = themeController.alternateBody;
    final dataStyle = themeController.small;
    return WizardReviewStepWrapper<VacationEntity?>(
      stepToJumpTo: 4,
      builder: (data) {
        return Visibility(
          visible: data != null,
          child: _MightyLabeledWidgets(
            label: context.loc.reviewStepVacationLabel,
            children: [
              _ShowValue(
                label: context.loc.reviewStepVacationDaysLabel,
                data: data?.days?.toString() ?? '',
                labelStyle: labelStyle,
                dataStyle: dataStyle,
              ),
              _ShowValue(
                label: context.loc.reviewStepVacationPaymentLabel,
                data: data?.paymentStatus?.label(context) ?? '',
                labelStyle: labelStyle,
                dataStyle: dataStyle,
              ),
            ],
          ),
        );
      },
    );
  }
}

class _TimeManagementReview extends StatelessWidget {
  const _TimeManagementReview({required this.themeController});
  final MightyThemeController themeController;

  @override
  Widget build(BuildContext context) {
    final labelStyle = themeController.alternateBody;
    final dataStyle = themeController.small;
    return WizardReviewStepWrapper<ProjectTimeManagementEntity?>(
      stepToJumpTo: 5,
      builder: (data) {
        final referencePeriod = data?.referencePeriod?.label(context) ?? '';
        return Visibility(
          visible: data != null,
          child: _MightyLabeledWidgets(
            label: context.loc.reviewStepTimeManagementLabel,
            children: [
              _ShowValue(
                label: context.loc.reviewStepTimeManagementReferencePeriodLabel,
                data: referencePeriod,
                labelStyle: labelStyle,
                dataStyle: dataStyle,
              ),
              _ShowValue(
                label: context.loc
                    .reviewStepTimeManagementWorkingHoursLabel(referencePeriod),
                data: data?.workingHours?.toString() ?? '',
                labelStyle: labelStyle,
                dataStyle: dataStyle,
              ),
            ],
          ),
        );
      },
    );
  }
}

class _MoneyManagementReview extends StatelessWidget {
  const _MoneyManagementReview({required this.themeController});
  final MightyThemeController themeController;

  @override
  Widget build(BuildContext context) {
    final labelStyle = themeController.alternateBody;
    final dataStyle = themeController.small;
    return WizardReviewStepWrapper<ProjectMoneyManagementEntity?>(
      stepToJumpTo: 6,
      builder: (data) {
        final paymentInterval = data?.paymentInterval?.label(context) ?? '';
        final currency = data?.currency?.label ?? '';
        return Visibility(
          visible: data != null,
          child: _MightyLabeledWidgets(
            label: context.loc.reviewStepMoneyManagementLabel,
            children: [
              _ShowValue(
                label:
                    context.loc.reviewStepMoneyManagementPaymentIntervalLabel,
                data: paymentInterval,
                labelStyle: labelStyle,
                dataStyle: dataStyle,
              ),
              _ShowValue(
                label: context.loc.reviewStepMoneyManagementCurrencyLabel,
                data: currency,
                labelStyle: labelStyle,
                dataStyle: dataStyle,
              ),
              _ShowValue(
                label: context.loc.reviewStepMoneyManagementPaymentLabel(
                  paymentInterval,
                  currency,
                ),
                data: data?.payment?.toString() ?? '',
                labelStyle: labelStyle,
                dataStyle: dataStyle,
              ),
            ],
          ),
        );
      },
    );
  }
}

class _WorkplaceReview extends StatelessWidget {
  const _WorkplaceReview({required this.themeController});

  final MightyThemeController themeController;

  @override
  Widget build(BuildContext context) {
    return WizardReviewStepWrapper<Workplace?>(
      stepToJumpTo: 7,
      builder: (data) {
        return Visibility(
          visible: data != null,
          child: _MightyLabeledWidgets(
            label: context.loc.reviewStepWorkplaceLabel,
            children: [
              _ShowValue(
                label: data?.label(context) ?? '',
                data: '',
                labelStyle: themeController.alternateBody,
              ),
            ],
          ),
        );
      },
    );
  }
}

class _ShowValue extends StatelessWidget {
  const _ShowValue({
    required this.label,
    required this.data,
    this.dataStyle,
    // ignore: unused_element
    this.verticalPadding = SpaceTokens.mediumSmall,
    this.labelStyle,
  });

  final String label;
  final String data;
  final TextStyle? labelStyle;
  final TextStyle? dataStyle;

  final double verticalPadding;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: verticalPadding),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: labelStyle,
          ),
          Text(
            data,
            style: dataStyle ?? labelStyle,
          ),
        ],
      ),
    );
  }
}

class _MightyLabeledWidgets extends ConsumerWidget {
  const _MightyLabeledWidgets({
    required this.label,
    required this.children,
    // ignore: unused_element
    this.bottomPadding = SpaceTokens.mediumSmall,
  });

  final String label;
  final List<Widget> children;
  final double bottomPadding;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.watchStateProvider(
      context,
      mightyThemeControllerProvider,
      mightyThemeControllerProvider.notifier,
    );
    return Column(
      children: [
        _LabeledWidgets(
          label: label,
          labelStyle: theme.controller.smallHeadline,
          backgroundColor: theme.controller.alternateBackgroundColor,
          children: children,
        ),
        SizedBox(height: bottomPadding),
      ],
    );
  }
}

class _LabeledWidgets extends StatelessWidget {
  const _LabeledWidgets({
    required this.label,
    required this.children,
    this.backgroundColor,
    this.labelStyle,
  });

  final String label;
  final TextStyle? labelStyle;
  final List<Widget> children;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(SpaceTokens.mediumSmall),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(SpaceTokens.mediumSmall),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: labelStyle,
          ),
          ...children,
        ],
      ),
    );
  }
}
