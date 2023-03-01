import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:my_time/common/widgets/responsive_center.dart';
import 'package:my_time/common/widgets/standard_button.dart';
import 'package:my_time/constants/breakpoints.dart';
import 'package:my_time/features/projects_groups/presentation/2_add_project_screen/group_selection_field.dart';
import 'package:my_time/features/projects_groups/presentation/2_add_project_screen/project_name_field.dart';
import 'package:my_time/global/globals.dart';
import 'package:my_time/router/app_route.dart';

class AddProjectScreen extends StatefulWidget {
  final String? group;
  const AddProjectScreen({
    Key? key,
    this.group,
  }) : super(key: key);

  @override
  State<AddProjectScreen> createState() => _AddProjectScreenState();
}

class _AddProjectScreenState extends State<AddProjectScreen> {
  final String selectGroupText = "Select a Group";
  late String selectedGroup;
  late bool isExpandable = false;
  TextEditingController projectNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    selectedGroup = widget.group ?? selectGroupText;
    if (selectedGroup == selectGroupText) {
      isExpandable = true;
    }
  }

  void onBtnTap() {
    if (selectedGroup == selectGroupText ||
        projectNameController.text.isEmpty) {
      return;
    }
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
      bottomNavigationBar: SizedBox(
        height: kBottomNavigationBarHeight,
        child: ResponsiveAlign(
          alignment: Alignment.center,
          maxContentWidth: Breakpoint.desktop,
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
          child: StandardButton(
            text: "Save",
            width: Breakpoint.mobile,
            onPressed: () => onBtnTap(),
          ),
        ),
      ),
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          AppBar(
            leading: IconButton(
              icon: const Icon(
                Icons.arrow_back,
                color: GlobalProperties.textAndIconColor,
              ),
              onPressed: () => pop(),
            ),
            title: const Text(
              "New Project",
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
                alignment: Alignment.topCenter,
                padding: const EdgeInsets.fromLTRB(16, 30, 16, 0),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      GroupSelectionField(
                        selectedGroup: selectedGroup,
                        isExpandable: isExpandable,
                        onSelectionChanged: (selectedValue) {
                          setState(() {
                            selectedGroup = selectedValue;
                          });
                        },
                      ),
                      ProjectNameField(
                        projectNameController: projectNameController,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
