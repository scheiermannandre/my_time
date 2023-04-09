import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:my_time/common/extensions/async_value_extensions.dart';
import 'package:my_time/common/widgets/bottom_nav_bar_button.dart';
import 'package:my_time/common/widgets/loading_error_widget.dart';
import 'package:my_time/common/widgets/responsive_center.dart';
import 'package:my_time/layers/interface/dto/group_dto.dart';
import 'package:my_time/layers/presentation/2_add_project_screen/add_project_screen_loading_state.dart';
import 'package:my_time/layers/presentation/2_add_project_screen/add_project_screen_controller.dart';
import 'package:my_time/layers/presentation/2_add_project_screen/group_and_project_fields.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AddProjectScreen extends HookConsumerWidget {
  const AddProjectScreen({Key? key, this.groupId}) : super(key: key);
  final String? groupId;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final projectNameController = useTextEditingController(text: '');
    final controller =
        ref.watch(addProjectScreenControllerProvider(groupId ?? "").notifier);
    final state =
        ref.watch(addProjectScreenControllerProvider(groupId ?? "")).value;

    final AsyncValue<List<GroupDTO>> groupsListValue;
    if (groupId == null) {
      groupsListValue = ref.watch(groupsProvider(groupId));
      ref.listen<AsyncValue>(
        groupsProvider(groupId),
        (_, state) => state.showAlertDialogOnError(context),
      );
    } else {
      groupsListValue = ref.watch(singleGroupProvider(groupId.toString()));
      ref.listen<AsyncValue>(
        singleGroupProvider(groupId.toString()),
        (_, state) => state.showAlertDialogOnError(context),
      );
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
          ),
          onPressed: () => controller.pop(context),
        ),
        title: Text(
          AppLocalizations.of(context)!.addProjectScreenTitle,
        ),
        elevation: 0,
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      bottomNavigationBar: Container(
        color: Theme.of(context).colorScheme.background,
        child: NavBarSubmitButton(
          isLoading: state!.isLoading,
          btnText: AppLocalizations.of(context)!.addProjectScreenBtnLabel,
          onBtnTap: state.isLoading
              ? null
              : () => controller.onBtnTap(context, projectNameController.text),
        ),
      ),
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Padding(
        padding: const EdgeInsets.only(top: 100),
        child: RefreshIndicator(
          color: Theme.of(context).colorScheme.primary,
          key: state.refreshIndicatorKey,
          onRefresh: () async {
            await AsyncValue.guard(() => ref
                .refresh(groupsProvider(groupId).future)
                .timeout(const Duration(seconds: 20)));
            return;
          },
          child: ScrollConfiguration(
            behavior: ScrollConfiguration.of(context).copyWith(
              dragDevices: {
                PointerDeviceKind.touch,
                PointerDeviceKind.mouse,
              },
            ),
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: groupsListValue.when(
                data: (groups) => GroupAndProjectFields(
                  groups: groups,
                  expansionTile: state.expansionTile,
                  selectedGroup: state.selectedGroupName,
                  defaultSelectedGroup: AppLocalizations.of(context)!
                      .addProjectScreenGroupFieldDropDownDefaultLabel,
                  isExpandable: state.isExpandable,
                  onListTileTap: (groups, index) =>
                      controller.onGroupDropDownListTileTap(groups, index),
                  controller: projectNameController,
                ),
                error: (ex, st) => LoadingErrorWidget(
                  onRefresh: () =>
                      state.refreshIndicatorKey.currentState?.show(),
                ),
                loading: () => const ResponsiveAlign(
                  alignment: Alignment.topCenter,
                  padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
                  child: SingleChildScrollView(
                    child: AddGroupScreenLoadingState(),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
