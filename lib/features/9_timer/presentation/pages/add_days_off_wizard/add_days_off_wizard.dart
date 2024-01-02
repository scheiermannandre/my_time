import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:my_time/common/extensions/build_context_extension.dart';
import 'package:my_time/domain/group_domain/models/project_entity.dart';
import 'package:my_time/features/7_groups_overview/domain/usecase_services/project_service.dart';
import 'package:my_time/features/9_timer/domain/entities/entry_type.dart';
import 'package:my_time/features/9_timer/presentation/pages/add_days_off_wizard/days_off_review_step.dart';
import 'package:my_time/features/9_timer/presentation/pages/add_days_off_wizard/steps/step1_date_range.dart';
import 'package:my_time/features/9_timer/presentation/pages/add_days_off_wizard/steps/step2_compensation.dart';
import 'package:my_time/features/9_timer/presentation/pages/add_days_off_wizard/steps/step3_description.dart';
import 'package:my_time/features/9_timer/presentation/state_management/add_days_off_wizard_controller.dart';
import 'package:my_time/features/9_timer/presentation/state_management/add_entry_wizard_controller.dart';
import 'package:my_time/foundation/core/util/extentions/widget_ref_extension.dart';
import 'package:my_time/foundation/core/widgets/wizard/wizard/wizard.dart';
import 'package:my_time/foundation/core/widgets/wizard/wizard/wizard_step_indicator.dart';
import 'package:my_time/foundation/core/widgets/wizard/wizard_button_data.dart';

/// A widget representing the add project wizard.
class AddDaysOffWizard extends ConsumerWidget {
  /// Constructs an [AddDaysOffWizard] with required parameters.
  AddDaysOffWizard({
    required String groupId,
    required String projectId,
    required int entryType,
    required String projectName,
    super.key,
  })  : _groupId = groupId,
        _projectId = projectId,
        _entryType = EntryType.values[entryType],
        _projectName = projectName;

  final String _groupId;
  final String _projectId;
  final EntryType _entryType;
  final String _projectName;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final project = ref.watchAndListenAsyncValueErrors(
      context,
      fetchProjectProvider(groupId: _groupId, projectId: _projectId),
    );
    ref.watchAndListenAsyncValueErrors(
      context,
      addEntryWizardControllerProvider,
    );

    return project.when(
      data: (data) => AddDaysOffWizardInherited(
        entryType: _entryType,
        project: data,
        child: Wizard(
          onFinish: (event) async {
            event.data[3] = _projectName;
            final isSuccess = await ref
                .read(addDaysOffWizardControllerProvider.notifier)
                .addEntries(_groupId, _projectId, _entryType, event.data);

            if (!isSuccess) return;
            if (!context.mounted) return;
            context.pop();
          },
          previousBtnTitle: WizardButtonData(
            title: context.loc.previousBtn,
            type: WizardBtnType.previous,
          ),
          nextBtnTitle: WizardButtonData(
            title: context.loc.nextBtn,
            type: WizardBtnType.forward,
          ),
          skipBtnTitle: WizardButtonData(
            title: context.loc.skipBtn,
          ),
          lastPageBtnTitle: WizardButtonData(
            title: context.loc.backToReviewBtn,
          ),
          finishBtnTitle: WizardButtonData(
            title: context.loc.finishBtn,
          ),
          stepStyle: const StepIndicatorStyle(),
          steps: const [
            Step1DateRange(),
            Step2Compensation(),
            Step3Description(),
          ],
          reviewStep: const DaysOffReviewStep(),
        ),
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stackTrace) => Center(child: Text(error.toString())),
    );
  }
}

/// A widget that provides the [NewProjectModel] to its children.
class AddDaysOffWizardInherited extends InheritedWidget {
  /// Constructs an [AddDaysOffWizardInherited] with required parameters.
  const AddDaysOffWizardInherited({
    required this.project,
    required super.child,
    required this.entryType,
    super.key,
  });

  /// The [NewProjectModel] to provide.
  final NewProjectModel project;

  /// The [EntryType] to provide.
  final EntryType entryType;

  /// Method to get the [AddDaysOffWizardInherited] from the [BuildContext].
  static AddDaysOffWizardInherited? of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<AddDaysOffWizardInherited>();
  }

  @override
  bool updateShouldNotify(AddDaysOffWizardInherited oldWidget) {
    return project != oldWidget.project;
  }
}
