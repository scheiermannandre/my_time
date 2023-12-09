import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:my_time/common/extensions/build_context_extension.dart';
import 'package:my_time/config/theme/tokens/space_tokens.dart';
import 'package:my_time/config/theme/tokens/text_style_tokens.dart';
import 'package:my_time/core/widgets/spaced_column.dart';
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

/// Review Step in the add project wizard.
class ReviewStep extends ConsumerWidget {
  /// Constructor for the ReviewStep widget.
  const ReviewStep({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return WizardReviewStep(
      stepsLength: 8,
      builder: (controller) => WizardReviewStepEventListener(
        controller: controller,
        child: const SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: SpaceTokens.medium,
              vertical: SpaceTokens.medium,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _GroupReview(),
                _ProjectNameReview(),
                _SickDaysReview(),
                _PublicHolidaysReview(),
                _VacationInfoReview(),
                _TimeManagementReview(),
                _MoneyManagementReview(),
                _WorkplaceReview(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _GroupReview extends StatelessWidget {
  const _GroupReview();

  @override
  Widget build(BuildContext context) {
    return _ReviewBlock<GroupEntity?>(
      label: context.loc.reviewStepGroupLabel,
      stepToJumpTo: 0,
      evaluateVisibility: (data) {
        if (data == null) return false;
        return true;
      },
      builder: (data) => [
        _ShowValue(
          label: data?.name ?? '',
          data: '',
        ),
      ],
    );
  }
}

class _ProjectNameReview extends StatelessWidget {
  const _ProjectNameReview();

  @override
  Widget build(BuildContext context) {
    return _ReviewBlock<String?>(
      label: context.loc.reviewStepProjectNameLabel,
      stepToJumpTo: 1,
      evaluateVisibility: (data) {
        if (data == null) return false;
        return true;
      },
      builder: (data) => [
        _ShowValue(
          label: data ?? '',
          data: '',
        ),
      ],
    );
  }
}

class _SickDaysReview extends StatelessWidget {
  const _SickDaysReview();

  @override
  Widget build(BuildContext context) {
    return _ReviewBlock<PaymentStatus?>(
      label: context.loc.reviewStepSickDaysPaymentLabel,
      stepToJumpTo: 2,
      evaluateVisibility: (data) {
        if (data == null) return false;
        return true;
      },
      builder: (data) => [
        _ShowValue(
          label: data?.label(context) ?? '',
          data: '',
        ),
      ],
    );
  }
}

class _PublicHolidaysReview extends StatelessWidget {
  const _PublicHolidaysReview();

  @override
  Widget build(BuildContext context) {
    return _ReviewBlock<PaymentStatus?>(
      label: context.loc.reviewStepPublicHolidaysPaymentLabel,
      stepToJumpTo: 3,
      evaluateVisibility: (data) {
        if (data == null) return false;
        return true;
      },
      builder: (data) => [
        _ShowValue(
          label: data?.label(context) ?? '',
          data: '',
        ),
      ],
    );
  }
}

class _VacationInfoReview extends StatelessWidget {
  const _VacationInfoReview();

  @override
  Widget build(BuildContext context) {
    return _ReviewBlock<VacationEntity?>(
      label: context.loc.reviewStepVacationLabel,
      stepToJumpTo: 4,
      evaluateVisibility: (data) {
        if (data == null) return false;

        if (data.paymentStatus == null || data.days == null) {
          return false;
        }
        return true;
      },
      builder: (data) => [
        _ShowValue(
          label: context.loc.reviewStepVacationDaysLabel,
          data: data?.days?.toString() ?? '',
        ),
        _ShowValue(
          label: context.loc.reviewStepVacationPaymentLabel,
          data: data?.paymentStatus?.label(context) ?? '',
        ),
      ],
    );
  }
}

class _TimeManagementReview extends StatelessWidget {
  const _TimeManagementReview();

  @override
  Widget build(BuildContext context) {
    return _ReviewBlock<ProjectTimeManagementEntity?>(
      label: context.loc.reviewStepTimeManagementLabel,
      stepToJumpTo: 5,
      evaluateVisibility: (data) {
        if (data == null) return false;

        if (data.referencePeriod == null || data.workingHours == null) {
          return false;
        }
        return true;
      },
      builder: (data) => [
        _ShowValue(
          label: context.loc.reviewStepTimeManagementReferencePeriodLabel,
          data: data?.referencePeriod?.label(context) ?? '',
        ),
        _ShowValue(
          label: context.loc.reviewStepTimeManagementWorkingHoursLabel(
            data?.referencePeriod?.label(context) ?? '',
          ),
          data: data?.workingHours?.toString() ?? '',
        ),
      ],
    );
  }
}

class _MoneyManagementReview extends StatelessWidget {
  const _MoneyManagementReview();

  @override
  Widget build(BuildContext context) {
    return _ReviewBlock<ProjectMoneyManagementEntity?>(
      label: context.loc.reviewStepMoneyManagementLabel,
      stepToJumpTo: 6,
      evaluateVisibility: (data) {
        if (data == null) return false;

        if (data.paymentInterval == null ||
            data.payment == null ||
            data.currency == null) {
          return false;
        }
        return true;
      },
      builder: (data) => [
        _ShowValue(
          label: context.loc.reviewStepMoneyManagementPaymentIntervalLabel,
          data: data?.paymentInterval?.label(context) ?? '',
        ),
        _ShowValue(
          label: context.loc.reviewStepMoneyManagementCurrencyLabel,
          data: data?.currency?.label ?? '',
        ),
        _ShowValue(
          label: context.loc.reviewStepMoneyManagementPaymentLabel(
            data?.paymentInterval?.label(context) ?? '',
            data?.currency?.label ?? '',
          ),
          data: data?.payment?.toString() ?? '',
        ),
      ],
    );
  }
}

class _WorkplaceReview extends StatelessWidget {
  const _WorkplaceReview();

  @override
  Widget build(BuildContext context) {
    return _ReviewBlock<Workplace?>(
      label: context.loc.reviewStepWorkplaceLabel,
      stepToJumpTo: 7,
      evaluateVisibility: (data) {
        if (data == null) return false;
        return true;
      },
      builder: (data) => [
        _ShowValue(
          label: data?.label(context) ?? '',
          data: '',
        ),
      ],
    );
  }
}

class _ShowValue extends StatelessWidget {
  const _ShowValue({
    required this.label,
    required this.data,
  });

  final String label;
  final String data;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
        ),
        Text(
          data,
          style: TextStyleTokens.bodyMedium(null),
        ),
      ],
    );
  }
}

class _ReviewBlock<T> extends StatefulWidget {
  const _ReviewBlock({
    required this.stepToJumpTo,
    required this.builder,
    required this.label,
    required this.evaluateVisibility,
    super.key,
  });

  final int stepToJumpTo;
  final List<Widget> Function(T?) builder;
  final String label;
  final bool Function(T? data) evaluateVisibility;

  @override
  State<_ReviewBlock<T>> createState() => _ReviewBlockState<T>();
}

class _ReviewBlockState<T> extends State<_ReviewBlock<T>> {
  bool _isVisible = false;

  void postFrameCallback(T? data) {
    if (data == null) return;
    if (!mounted) return;
    final isVisible = widget.evaluateVisibility(data);
    if (_isVisible == isVisible) return;
    setState(() {
      _isVisible = isVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: _isVisible ? null : 0,
      height: _isVisible ? null : 0,
      child: Padding(
        padding: const EdgeInsets.only(bottom: SpaceTokens.mediumSmall),
        child: _LabeledWidgets(
          label: widget.label,
          children: [
            WizardReviewStepWrapper<T?>(
              stepToJumpTo: widget.stepToJumpTo,
              builder: (data) {
                WidgetsBinding.instance
                    .addPostFrameCallback((_) => postFrameCallback(data));
                return Visibility(
                  visible: data != null,
                  child: SingleChildScrollView(
                    child: SpacedColumn(
                      spacing: SpaceTokens.mediumSmall,
                      children: widget.builder(data),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _LabeledWidgets extends StatelessWidget {
  const _LabeledWidgets({
    required this.label,
    required this.children,
  });

  final String label;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return SpacedColumn(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: SpaceTokens.small,
      children: [
        Text(
          label,
          style: TextStyleTokens.bodyMedium(null),
        ),
        ...children,
      ],
    );
  }
}
