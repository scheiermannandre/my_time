import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:my_time/common/extensions/build_context_extension.dart';
import 'package:my_time/config/theme/mighty_theme.dart';
import 'package:my_time/config/theme/space_tokens.dart';
import 'package:my_time/core/util/extentions/string_extension.dart';
import 'package:my_time/core/widgets/mighty_text_form_field.dart';
import 'package:my_time/core/widgets/wizard/wizard_step/wizard_step_event_listener.dart';
import 'package:my_time/core/widgets/wizard/wizard_step/wizard_step_wrapper.dart';

/// Step 2: Project Name Entry Step in a wizard.
class Step2ProjectName extends StatelessWidget {
  /// Constructor for the Step2ProjectName widget.
  const Step2ProjectName({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return WizardStepWrapper<String?>(
      title: context.loc.step2Title,
      stepNumber: 1,
      showNextBtn: true,
      isSkipable: false,
      isNextBtnEnabled: false,
      builder: (context, data, controller) {
        return WizardStepEventListener(
          controller: controller,
          onNextEvent: (event) {},
          child: _ProjectNameStep(
            name: data,
            saveName: controller.saveData,
            enableNext: controller.enableNext,
            disableNext: controller.disableNext,
          ),
        );
      },
    );
  }
}

class _ProjectNameStep extends HookConsumerWidget {
  const _ProjectNameStep({
    required this.saveName,
    required this.enableNext,
    required this.disableNext,
    required this.name,
  });

  final String? name;
  final void Function(String value) saveName;
  final void Function() enableNext;
  final void Function() disableNext;

  String? validate(BuildContext context, String? value) {
    if (value == null || value.isEmpty) {
      return context.loc.step2ValidationEmpty;
    }
    if (!value.containsOnlyLetters()) {
      return context.loc.step2ValidationInvalidChars;
    }
    return null;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textController = useTextEditingController(text: name ?? '');
    final themeController = ref.watch(mightyThemeControllerProvider.notifier);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: SpaceTokens.medium),
      child: MightyTextFormField(
        onChanged: (value, isValid) {
          if (!isValid) {
            disableNext();
            return;
          }
          enableNext();
          saveName(value);
        },
        validator: (value) => validate(context, value),
        controller: textController,
        mightyThemeController: themeController,
        autofocus: name == null,
        onEditingComplete: () {
          if (validate(context, textController.text) != null) return;
          FocusScope.of(context).unfocus();
        },
      ),
    );
  }
}
