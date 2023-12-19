import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:my_time/common/extensions/build_context_extension.dart';
import 'package:my_time/core/util/extentions/widget_ref_extension.dart';
import 'package:my_time/core/widgets/wizard/wizard/wizard.dart';
import 'package:my_time/core/widgets/wizard/wizard/wizard_step_indicator.dart';
import 'package:my_time/core/widgets/wizard/wizard_button_data.dart';
import 'package:my_time/features/7_groups_overview/domain/entities/project_entity.dart';
import 'package:my_time/features/7_groups_overview/domain/usecase_services/project_service.dart';
import 'package:my_time/features/9_timer/presentation/pages/add_entry_wizard/review_step.dart';
import 'package:my_time/features/9_timer/presentation/pages/add_entry_wizard/steps/step1_date.dart';
import 'package:my_time/features/9_timer/presentation/pages/add_entry_wizard/steps/step2_start_time.dart';
import 'package:my_time/features/9_timer/presentation/pages/add_entry_wizard/steps/step3_end_time.dart';
import 'package:my_time/features/9_timer/presentation/pages/add_entry_wizard/steps/step4_break_time.dart';
import 'package:my_time/features/9_timer/presentation/pages/add_entry_wizard/steps/step5_workplace.dart';
import 'package:my_time/features/9_timer/presentation/pages/add_entry_wizard/steps/step6_description.dart';
import 'package:my_time/features/9_timer/presentation/state_management/add_entry_wizard_controller.dart';

/// A widget representing the add project wizard.
class AddEntryWizard extends ConsumerWidget {
  /// Constructs an [AddEntryWizard] with required parameters.
  const AddEntryWizard({
    required String groupId,
    required String projectId,
    super.key,
  })  : _groupId = groupId,
        _projectId = projectId;

  final String _groupId;
  final String _projectId;

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
      data: (data) => AddEntryWizardInherited(
        project: data,
        child: Wizard(
          onFinish: (event) async {
            final isSuccess = await ref
                .read(addEntryWizardControllerProvider.notifier)
                .addEntry(_groupId, _projectId, event.data);

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
            Step1Date(),
            Step2StartTime(),
            Step3EndTime(),
            Step4BreakTime(),
            Step5Workplace(),
            Step6Description(),
          ],
          reviewStep: const ReviewStep(),
        ),
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stackTrace) => Center(child: Text(error.toString())),
    );
  }
}

/// A widget that provides the [ProjectEntity] to its children.
class AddEntryWizardInherited extends InheritedWidget {
  /// Constructs an [AddEntryWizardInherited] with required parameters.
  const AddEntryWizardInherited({
    required this.project,
    required super.child,
    super.key,
  });

  /// The [ProjectEntity] to provide.
  final ProjectEntity project;

  /// Method to get the [AddEntryWizardInherited] from the [BuildContext].
  static AddEntryWizardInherited? of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<AddEntryWizardInherited>();
  }

  @override
  bool updateShouldNotify(AddEntryWizardInherited oldWidget) {
    return project != oldWidget.project;
  }
}
