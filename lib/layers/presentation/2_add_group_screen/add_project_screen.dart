import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:my_time/common/extensions/async_value_extensions.dart';
import 'package:my_time/common/widgets/async_value_widget.dart';
import 'package:my_time/common/widgets/bottom_nav_bar_button.dart';
import 'package:my_time/layers/presentation/2_add_group_screen/add_project_screen_controller.dart';
import 'package:my_time/layers/presentation/2_add_group_screen/group_and_project_fields.dart';
import 'package:my_time/global/globals.dart';

class AddProjectScreen extends HookConsumerWidget {
  const AddProjectScreen({Key? key, this.groupId}) : super(key: key);
  final String? groupId;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final projectNameController = useTextEditingController(text: '');
    final controller =
        ref.watch(addProjectScreenControllerProvider(groupId).notifier);
    final state = ref.watch(addProjectScreenControllerProvider(groupId));

    final groupsListValue = ref.watch(groupsProvider(groupId));

    ref.listen<AsyncValue>(
      groupsProvider(groupId),
      (_, state) => state.showAlertDialogOnError(context),
    );
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: GlobalProperties.textAndIconColor,
          ),
          onPressed: () => controller.pop(context),
        ),
        title: const Text(
          "New Project",
          style: TextStyle(color: GlobalProperties.textAndIconColor),
        ),
        elevation: 0,
        backgroundColor: GlobalProperties.secondaryAccentColor,
      ),
      bottomNavigationBar: Container(
        color: GlobalProperties.backgroundColor,
        child: NavBarSubmitButton(
          isLoading: state.isLoading,
          btnText: "Save",
          onBtnTap: state.isLoading
              ? null
              : () => controller.onBtnTap(context, projectNameController.text),
        ),
      ),
      backgroundColor: GlobalProperties.secondaryAccentColor,
      body: Padding(
        padding: const EdgeInsets.only(top: 100),
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: groupId == null
              ? AsyncValueWidget(
                  value: groupsListValue,
                  data: (groups) => GroupAndProjectFields(
                    groups: groups,
                    expansionTile: state.expansionTile,
                    selectedGroup: state.selectedGroupName,
                    isExpandable: state.isExpandable,
                    onListTileTap: (groups, index) =>
                        controller.onGroupDropDownListTileTap(groups, index),
                    controller: projectNameController,
                  ),
                )
              : GroupAndProjectFields(
                  groups: const [],
                  controller: projectNameController,
                  selectedGroup: state.selectedGroupName,
                ),
        ),
      ),
    );
  }
}
