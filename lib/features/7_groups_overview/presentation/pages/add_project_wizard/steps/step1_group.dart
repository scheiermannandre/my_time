import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_time/common/extensions/build_context_extension.dart';
import 'package:my_time/config/theme/mighty_theme.dart';
import 'package:my_time/config/theme/tokens/space_tokens.dart';
import 'package:my_time/core/util/extentions/widget_ref_extension.dart';
import 'package:my_time/core/widgets/async_value_widget.dart';
import 'package:my_time/core/widgets/loading_indicator.dart';
import 'package:my_time/core/widgets/mighty_loading_error_widget.dart';
import 'package:my_time/core/widgets/mighty_splash_list_tile.dart';
import 'package:my_time/core/widgets/wizard/wizard_step/wizard_step_event_listener.dart';
import 'package:my_time/core/widgets/wizard/wizard_step/wizard_step_wrapper.dart';
import 'package:my_time/features/7_groups_overview/data/repositories/group_repository_impl.dart';
import 'package:my_time/features/7_groups_overview/domain/entities/group_entity.dart';

/// Step 1: Group Selection Step in a wizard.
class Step1Group extends StatelessWidget {
  /// Constructor for the Step1Group widget.
  const Step1Group({super.key});

  @override
  Widget build(BuildContext context) {
    return WizardStepWrapper<GroupEntity?>(
      title: context.loc.step1Title,
      stepNumber: 0,
      showNextBtn: false,
      isSkipable: false,
      isNextBtnEnabled: false,
      builder: (context, data, controller) {
        return WizardStepEventListener(
          controller: controller,
          onNextEvent: (event) {},
          child: _GroupSelectionStep(
            data: data,
            onSelect: (group) {
              controller
                ..next()
                ..saveData(group)
                ..showNextBtn();
            },
          ),
        );
      },
    );
  }
}

class _GroupSelectionStep extends ConsumerStatefulWidget {
  const _GroupSelectionStep({
    required this.data,
    required this.onSelect,
  });

  final GroupEntity? data;
  final void Function(GroupEntity) onSelect;
  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _GroupSelectionStepState();
}

class _GroupSelectionStepState extends ConsumerState<_GroupSelectionStep> {
  GroupEntity? pickedGroup;

  @override
  void initState() {
    pickedGroup = widget.data;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final mightyTheme =
        ref.watchStateProvider<MightyThemeController, SystemThemeMode>(
      context,
      mightyThemeControllerProvider,
      mightyThemeControllerProvider.notifier,
    );

    final groups = ref.watch(groupsStreamProvider);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: SpaceTokens.medium),
      child: AsyncValueWidget(
        value: groups,
        data: (groups) {
          return ListView.separated(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: groups.length,
            itemBuilder: (context, index) {
              return MightySplashListTile(
                themeController: mightyTheme.controller,
                text: groups[index].name,
                showIcon: pickedGroup?.name == groups[index].name,
                iconData: Icons.check,
                onPressed: () {
                  setState(() {
                    pickedGroup = groups[index];
                  });

                  widget.onSelect(groups[index]);
                },
              );
            },
            separatorBuilder: (context, index) => const SizedBox(
              height: SpaceTokens.verySmall,
            ),
          );
        },
        loading: LoadingIndicator.new,
        error: (error, stackTrace) => MightyLoadingErrorWidget(
          onRefresh: () {
            ref.invalidate(groupsStreamProvider);
          },
          themeController: mightyTheme.controller,
        ),
      ),
    );
  }
}
