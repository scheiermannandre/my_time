import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:my_time/common/widgets/responsive_center.dart';
import 'package:my_time/features/projects_groups/presentation/1_add_group_screen/bottom_nav_bar_button.dart';
import 'package:my_time/features/projects_groups/presentation/1_add_group_screen/group_name_field.dart';
import 'package:my_time/global/globals.dart';
import 'package:my_time/router/app_route.dart';

class AddGroupScreen extends StatefulWidget {
  const AddGroupScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<AddGroupScreen> createState() => _AddGroupScreenState();
}

class _AddGroupScreenState extends State<AddGroupScreen> {
  TextEditingController groupNameController = TextEditingController();
  @override
  void initState() {
    super.initState();
  }

  void onBtnTap() {
    if (groupNameController.text.isEmpty) {
      return;
    }
    //ToDo
    // add group to repo
    pop();
  }

  void pop() {
    if (context.canPop()) {
      context.pop();
    } else {
      context.pushReplacementNamed(AppRoute.home);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: NavBarButton(onBtnTap: () => onBtnTap()),
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          AppBar(
            leading: IconButton(
              icon: const Icon(
                Icons.arrow_back,
                color: GlobalProperties.textAndIconColor,
              ),
              onPressed: (() => pop()),
            ),
            title: const Text(
              "New Group",
              style: TextStyle(color: GlobalProperties.textAndIconColor),
            ),
            elevation: 0,
            backgroundColor: GlobalProperties.secondaryAccentColor,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 200),
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
        ],
      ),
    );
  }
}
