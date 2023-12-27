import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:my_time/common/extensions/build_context_extension.dart';
import 'package:my_time/common/extensions/date_time_extension.dart';
import 'package:my_time/features/7_groups_overview/domain/entities/enums/payment_status.dart';
import 'package:my_time/features/9_timer/domain/entities/entry_type.dart';
import 'package:my_time/features/9_timer/presentation/pages/add_days_off_wizard/add_days_off_wizard.dart';
import 'package:my_time/foundation/config/theme/tokens/space_tokens.dart';
import 'package:my_time/foundation/core/widgets/spaced_column.dart';
import 'package:my_time/foundation/core/widgets/wizard/wizard_review_step/review_card.dart';
import 'package:my_time/foundation/core/widgets/wizard/wizard_review_step/show_review_value.dart';
import 'package:my_time/foundation/core/widgets/wizard/wizard_review_step/wizard_review_step.dart';
import 'package:my_time/foundation/core/widgets/wizard/wizard_review_step/wizard_review_step_event_listener.dart';

/// Review Step in the add project wizard.
class DaysOffReviewStep extends ConsumerWidget {
  /// Constructor for the ReviewStep widget.
  const DaysOffReviewStep({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final entryType = AddDaysOffWizardInherited.of(context)!.entryType;
    return WizardReviewStep(
      stepsLength: 3,
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
                  DataCard(
                    label: context.loc.entryTypeLabel,
                    isVisible: true,
                    children: [Text(entryType.displayName(context))],
                  ),
                  const _DateReview(),
                  const _PaymentStatusReview(),
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

class _DateReview extends StatelessWidget {
  const _DateReview();
  List<Widget> _buildDateWidgets(List<DateTime?>? dates) {
    if (dates == null) return [];
    return dates
        .asMap()
        .entries
        .map(
          (entry) => ReviewDataValue(
            label:
                '''${entry.key + 1}. ${entry.value?.toFormattedDateString() ?? ''}''',
          ),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return ReviewDataCard<List<DateTime?>>(
      label: context.loc.entryDateRangeLabel,
      stepToJumpTo: 0,
      evaluateVisibility: (data) {
        if (data == null) return false;
        return true;
      },
      builder: _buildDateWidgets,
    );
  }
}

class _PaymentStatusReview extends StatelessWidget {
  const _PaymentStatusReview();

  @override
  Widget build(BuildContext context) {
    return ReviewDataCard<PaymentStatus?>(
      label: context.loc.entryPaymentStatusLabel,
      stepToJumpTo: 1,
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
      stepToJumpTo: 2,
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
