import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:my_time/common/extensions/async_value_extensions.dart';
import 'package:my_time/common/widgets/responsive_center.dart';
import 'package:my_time/common/widgets/bottom_nav_bar_button.dart';
import 'package:my_time/layers/presentation/1_add_group_screen/add_group_screen_controller.dart';
import 'package:my_time/layers/presentation/1_add_group_screen/group_name_field.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
          AppLocalizations.of(context)!.addGroupScreenTitle,
        ),
        elevation: 0,
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      bottomNavigationBar: Container(
        color: Theme.of(context).colorScheme.background,
        child: NavBarSubmitButton(
            isLoading: state.isLoading,
            btnText: AppLocalizations.of(context)!.addGroupScreenBtnLabel,
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
