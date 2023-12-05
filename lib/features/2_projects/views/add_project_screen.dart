import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:my_time/common/common.dart';
import 'package:my_time/features/2_projects/2_projects.dart';

/// The screen for adding a new project.
class AddProjectScreen extends HookConsumerWidget {
  /// Creates an [AddProjectScreen].
  const AddProjectScreen({super.key, this.groupId});

  /// The id of the group the project should be added to.
  final String? groupId;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final projectNameController = useTextEditingController(text: '');
    final controller =
        ref.watch(addProjectScreenControllerProvider(groupId ?? '').notifier);
    final state =
        ref.watch(addProjectScreenControllerProvider(groupId ?? '')).value;

    final AsyncValue<List<GroupModel>> groupsListValue;
    groupsListValue = ref.watch(groupsProvider(groupId));
    ref.listen<AsyncValue<void>>(
      groupsProvider(groupId),
      (_, state) => state.showAlertDialogOnError(context),
    );

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
          ),
          onPressed: () => controller.pop(context),
        ),
        title: Text(
          context.loc.addProjectScreenTitle,
        ),
        elevation: 0,
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      bottomNavigationBar: ColoredBox(
        color: Theme.of(context).colorScheme.background,
        child: NavBarSubmitButton(
          isLoading: state!.isLoading,
          btnText: context.loc.addProjectScreenBtnLabel,
          onBtnTap: state.isLoading
              ? null
              : () =>
                  controller.onAddBtnTap(context, projectNameController.text),
        ),
      ),
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Padding(
        padding: const EdgeInsets.only(top: 100),
        child: RefreshIndicator(
          color: Theme.of(context).colorScheme.primary,
          key: state.refreshIndicatorKey,
          onRefresh: () async {
            await AsyncValue.guard(
              () => ref
                  .refresh(groupsProvider(groupId).future)
                  .timeout(const Duration(seconds: 20)),
            );
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
                  defaultSelectedGroup: context
                      .loc.addProjectScreenGroupFieldDropDownDefaultLabel,
                  isExpandable: state.isExpandable,
                  onListTileTap: controller.onGroupDropDownListTileTap,
                  controller: projectNameController,
                ),
                error: (ex, st) => LoadingErrorWidgetDeprecated(
                  onRefresh: () =>
                      state.refreshIndicatorKey.currentState?.show(),
                ),
                loading: () => const ResponsiveAlign(
                  alignment: Alignment.topCenter,
                  padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
                  child: SingleChildScrollView(
                    child: AddProjectScreenLoadingState(),
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
