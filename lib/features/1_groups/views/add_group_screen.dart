import 'package:my_time/common/common.dart';
import 'package:my_time/features/1_groups/1_groups.dart';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class AddGroupScreen extends HookConsumerWidget {
  const AddGroupScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final groupNameController = useTextEditingController(text: '');
    final controller = ref.watch(addGroupScreenControllerProvider.notifier);
    final state = ref.watch(addGroupScreenControllerProvider);

    ref.listen<AsyncValue>(
      addGroupScreenControllerProvider,
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
          context.loc.addGroupScreenTitle,
        ),
        elevation: 0,
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      bottomNavigationBar: Container(
        color: Theme.of(context).colorScheme.background,
        child: NavBarSubmitButton(
            isLoading: state.isLoading,
            btnText: context.loc.addGroupScreenBtnLabel,
            onBtnTap: state.isLoading
                ? null
                : () => controller.onBtnTap(context, groupNameController.text)),
      ),
      backgroundColor: Theme.of(context).colorScheme.primary,
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
