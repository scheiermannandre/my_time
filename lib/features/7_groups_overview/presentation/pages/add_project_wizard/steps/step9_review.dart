import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:my_time/common/extensions/build_context_extension.dart';
import 'package:my_time/config/theme/tokens/space_tokens.dart';
import 'package:my_time/core/widgets/wizard/wizard_review_step/review_card.dart';
import 'package:my_time/core/widgets/wizard/wizard_review_step/show_review_value.dart';
import 'package:my_time/core/widgets/wizard/wizard_review_step/wizard_review_step.dart';
import 'package:my_time/core/widgets/wizard/wizard_review_step/wizard_review_step_event_listener.dart';
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
    return ReviewDataCard<GroupEntity?>(
      label: context.loc.reviewStepGroupLabel,
      stepToJumpTo: 0,
      evaluateVisibility: (data) {
        if (data == null) return false;
        return true;
      },
      builder: (data) => [
        ReviewLabeldDataValue(
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
    return ReviewDataCard<String?>(
      label: context.loc.reviewStepProjectNameLabel,
      stepToJumpTo: 1,
      evaluateVisibility: (data) {
        if (data == null) return false;
        return true;
      },
      builder: (data) => [
        ReviewLabeldDataValue(
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
    return ReviewDataCard<PaymentStatus?>(
      label: context.loc.reviewStepSickDaysPaymentLabel,
      stepToJumpTo: 2,
      evaluateVisibility: (data) {
        if (data == null) return false;
        return true;
      },
      builder: (data) => [
        ReviewLabeldDataValue(
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
    return ReviewDataCard<PaymentStatus?>(
      label: context.loc.reviewStepPublicHolidaysPaymentLabel,
      stepToJumpTo: 3,
      evaluateVisibility: (data) {
        if (data == null) return false;
        return true;
      },
      builder: (data) => [
        ReviewLabeldDataValue(
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
    return ReviewDataCard<VacationEntity?>(
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
        ReviewLabeldDataValue(
          label: context.loc.reviewStepVacationDaysLabel,
          data: data?.days?.toString() ?? '',
        ),
        ReviewLabeldDataValue(
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
    return ReviewDataCard<ProjectTimeManagementEntity?>(
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
        ReviewLabeldDataValue(
          label: context.loc.reviewStepTimeManagementReferencePeriodLabel,
          data: data?.referencePeriod?.label(context) ?? '',
        ),
        ReviewLabeldDataValue(
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
    return ReviewDataCard<ProjectMoneyManagementEntity?>(
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
        ReviewLabeldDataValue(
          label: context.loc.reviewStepMoneyManagementPaymentIntervalLabel,
          data: data?.paymentInterval?.label(context) ?? '',
        ),
        ReviewLabeldDataValue(
          label: context.loc.reviewStepMoneyManagementCurrencyLabel,
          data: data?.currency?.label ?? '',
        ),
        ReviewLabeldDataValue(
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
    return ReviewDataCard<Workplace?>(
      label: context.loc.reviewStepWorkplaceLabel,
      stepToJumpTo: 7,
      evaluateVisibility: (data) {
        if (data == null) return false;
        return true;
      },
      builder: (data) => [
        ReviewLabeldDataValue(
          label: data?.label(context) ?? '',
          data: '',
        ),
      ],
    );
  }
}
