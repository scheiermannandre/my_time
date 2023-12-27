import 'package:flutter/material.dart';
import 'package:my_time/common/extensions/build_context_extension.dart';
import 'package:my_time/features/7_groups_overview/domain/entities/enums/wokrplace.dart';
import 'package:my_time/features/7_groups_overview/presentation/widgets/workplace_selector.dart';
import 'package:my_time/features/9_timer/presentation/pages/add_entry_wizard/add_entry_wizard.dart';
import 'package:my_time/foundation/config/theme/tokens/space_tokens.dart';
import 'package:my_time/foundation/core/widgets/wizard/wizard_step/wizard_step_event_listener.dart';
import 'package:my_time/foundation/core/widgets/wizard/wizard_step/wizard_step_wrapper.dart';

/// Step 5 of the AddEntryWizard to select the workplace.
class Step5Workplace extends StatefulWidget {
  /// Constructor for the Step5Workplace widget.
  const Step5Workplace({
    super.key,
  });

  @override
  State<Step5Workplace> createState() => _Step5WorkplaceState();
}

class _Step5WorkplaceState extends State<Step5Workplace> {
  @override
  Widget build(BuildContext context) {
    final project = AddEntryWizardInherited.of(context)!.project;

    return WizardStepWrapper<Workplace?>(
      title: context.loc.step8Title,
      stepNumber: 4,
      showNextBtn: true,
      isSkipable: false,
      isNextBtnEnabled: true,
      builder: (context, data, controller) {
        var workplace = project.workplace;

        if (data != null && data != workplace) {
          workplace = data;
        }
        return WizardStepEventListener(
          controller: controller,
          onNextEvent: (event) {},
          child: _WorkplaceSelection(
            workplace: workplace,
            onSelect: (value) {
              controller
                ..next()
                ..saveData(value)
                ..showNextBtn();
            },
            onSave: (value) {
              controller.saveData(value);
            },
          ),
        );
      },
    );
  }
}

class _WorkplaceSelection extends StatefulWidget {
  const _WorkplaceSelection({
    required this.workplace,
    required this.onSave,
    required this.onSelect,
  });
  final Workplace? workplace;
  final void Function(Workplace) onSave;
  final void Function(Workplace) onSelect;

  @override
  State<_WorkplaceSelection> createState() => __WorkplaceSelectionState();
}

class __WorkplaceSelectionState extends State<_WorkplaceSelection> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.onSave.call(widget.workplace!);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: SpaceTokens.medium),
      child: WorkplaceSelector(
        workplace: widget.workplace,
        onChoose: (value) {
          widget.onSelect.call(value!);
        },
      ),
    );
  }
}
