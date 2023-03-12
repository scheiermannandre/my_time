import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:my_time/common/extensions/async_value_extensions.dart';
import 'package:my_time/common/widgets/responsive_center.dart';
import 'package:my_time/common/widgets/bottom_nav_bar_button.dart';
import 'package:my_time/features/projects_groups/presentation/1_add_group_screen/add_group_screen_controller.dart';
import 'package:my_time/features/projects_groups/presentation/1_add_group_screen/group_name_field.dart';
import 'package:my_time/global/globals.dart';

class AddGroupScreen extends HookConsumerWidget {
  const AddGroupScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final groupNameController = useTextEditingController(text: '');
    final controller = ref.watch(addGroupScreenControllerProvider.notifier);
    final state = ref.watch(addGroupScreenControllerProvider);

    ref.listen<AsyncValue>(
      addGroupScreenControllerProvider.select((state) => state.value),
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
          "New Group",
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
                : () => controller.onBtnTap(context, groupNameController.text)),
      ),
      backgroundColor: GlobalProperties.secondaryAccentColor,
      body: Padding(
        padding: const EdgeInsets.only(top: 100),
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: ResponsiveAlign(
            padding: const EdgeInsets.fromLTRB(16, 30, 16, 5),
            child: GroupNameField(
              groupNameController: groupNameController,
            ),
          ),
        ),
      ),
    );
  }
}
