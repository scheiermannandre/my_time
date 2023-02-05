// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:my_time/common/widgets/async_value_widget.dart';
import 'package:my_time/common/widgets/responsive_center.dart';
import 'package:my_time/constants/breakpoints.dart';
import 'package:my_time/features/projects_groups/groups/data/groups_repository.dart';
import 'package:my_time/global/globals.dart';

enum InitialLocation { group, project }

class AddProjectScreen extends StatefulWidget {
  final InitialLocation initialPage;
  final String group;
  const AddProjectScreen({
    Key? key,
    required this.initialPage,
    this.group = "",
  }) : super(key: key);

  @override
  State<AddProjectScreen> createState() => _AddProjectScreenState();
}

class _AddProjectScreenState extends State<AddProjectScreen> {
  late PageController controller;
  TextEditingController groupNameController = TextEditingController();
  TextEditingController projectNameController = TextEditingController();
  int currentIndex = 0;
  bool showBothBtn = false;
  String btnReturnText = "Return";
  String btnText = "Next";
  double returnBtnWidth = 0;
  double btnWidth = Breakpoint.mobile;
  EdgeInsets padding = const EdgeInsets.only(left: 0, right: 0);
  bool visible = false;
  @override
  void initState() {
    super.initState();
    switch (widget.initialPage) {
      case InitialLocation.group:
        break;
      case InitialLocation.project:
        if (widget.group.isNotEmpty) {
          groupNameController.text = widget.group;
          currentIndex = 1;
          btnText = "Save";
        }
        break;
    }
    controller = PageController(initialPage: currentIndex);
  }

  void changePage(int index) {
    setState(() {
      controller.animateToPage(index,
          duration: const Duration(milliseconds: 500), curve: Curves.easeOut);
    });
  }

  void onBtnTap() {
    switch (currentIndex) {
      case 0:
        {
          if (groupNameController.text.isEmpty) {
            return;
          }
          currentIndex++;
          btnText = "Save";
          visible = true;
          showBothBtn = true;
          returnBtnWidth = Breakpoint.mobile / 2;
          btnWidth = Breakpoint.mobile / 2;
          padding = const EdgeInsets.only(left: 5, right: 5);
          break;
        }
      case 1:
        {
          if (projectNameController.text.isEmpty) {
            return;
          }
          currentIndex++;
          //ToDo
          // Implement Add project logic!
          context.pop();
          return;
        }
      default:
        {
          return;
        }
    }
    changePage(currentIndex);
  }

  void onReturnBtnTap() {
    switch (currentIndex) {
      case 1:
        {
          currentIndex--;
          btnText = "Next";
          showBothBtn = true;
          visible = false;
          returnBtnWidth = 0;
          btnWidth = Breakpoint.mobile;
          padding = const EdgeInsets.only(left: 0, right: 0);
          break;
        }
      default:
        {
          return;
        }
    }
    changePage(currentIndex);
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
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 500),
                width: returnBtnWidth,
                child: SizedBox(
                  width: returnBtnWidth,
                  child: ElevatedButton(
                    onPressed: () => onReturnBtnTap(),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.fromLTRB(0, 12.5, 0, 12.5),
                      backgroundColor: GlobalProperties.secondaryAccentColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    child: AnimatedOpacity(
                      opacity: !visible ? 0.0 : 1.0,
                      duration: const Duration(milliseconds: 400),
                      child: Text(
                        btnReturnText,
                        maxLines: 1,
                        overflow: TextOverflow.fade,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            fontSize: 16,
                            color: GlobalProperties.textAndIconColor),
                      ),
                    ),
                  ),
                ),
              ),
              AnimatedPadding(
                padding: padding,
                duration: const Duration(milliseconds: 500),
              ),
              AnimatedContainer(
                duration: const Duration(milliseconds: 500),
                width: btnWidth,
                child: SizedBox(
                  width: btnWidth,
                  child: ElevatedButton(
                    onPressed: () => onBtnTap(),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.fromLTRB(0, 12.5, 0, 12.5),
                      backgroundColor: GlobalProperties.secondaryAccentColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5), // <-- Radius
                      ),
                    ),
                    child: AnimatedCrossFade(
                      duration: const Duration(milliseconds: 500),
                      crossFadeState: currentIndex == 0
                          ? CrossFadeState.showFirst
                          : CrossFadeState.showSecond,
                      firstChild: const Text(
                        "Next",
                        maxLines: 1,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 16,
                            color: GlobalProperties.textAndIconColor),
                      ),
                      secondChild: const Text(
                        "Save",
                        maxLines: 1,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 16,
                            color: GlobalProperties.textAndIconColor),
                      ),
                    ),
                  ),
                ),
              ),
            ],
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
              onPressed: (() => context.pop()),
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
                padding: const EdgeInsets.fromLTRB(16, 30, 16, 5),
                child: PageView(
                  physics: const NeverScrollableScrollPhysics(),
                  controller: controller,
                  children: [
                    GroupSelectionPage(controller: groupNameController),
                    ProjectNamingPage(
                      groupNameController: groupNameController,
                      projectNameController: projectNameController,
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ProjectNamingPage extends StatelessWidget {
  final TextEditingController groupNameController;
  final TextEditingController projectNameController;

  const ProjectNamingPage(
      {super.key,
      required this.groupNameController,
      required this.projectNameController});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        const Text(
          "Group",
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        TextField(
          readOnly: true,
          controller: groupNameController,
          cursorColor: GlobalProperties.shadowColor,
          decoration: InputDecoration(
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: GlobalProperties.shadowColor),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: GlobalProperties.shadowColor),
            ),
          ),
        ),
        const Padding(padding: EdgeInsets.only(top: 20)),
        const Text(
          "Project Name",
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        TextField(
          controller: projectNameController,
          cursorColor: GlobalProperties.shadowColor,
          decoration: InputDecoration(
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: GlobalProperties.shadowColor),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: GlobalProperties.shadowColor),
            ),
          ),
        ),
      ],
    );
  }
}

class GroupSelectionPage extends StatelessWidget {
  final TextEditingController controller;
  const GroupSelectionPage({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(bottom: 12),
          child: Text(
            "Group",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
        ),
        Expanded(
          child: Consumer(
            builder: (context, ref, child) {
              final groupsListValue = ref.watch(groupsListStreamProvider);
              return AsyncValueWidget(
                value: groupsListValue,
                data: (groups) => groups.isEmpty
                    ? Center(
                        child: Text(
                          'No projects found',
                          style: Theme.of(context).textTheme.headline4,
                        ),
                      )
                    : ResponsiveAlign(
                        padding: const EdgeInsets.only(top: 5, bottom: 5),
                        child: NewCustomExpansionTile(
                          itemCount: groups.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                              title: Text(groups[index].name),
                              onTap: () {
                                controller.text = groups[index].name;
                              },
                              contentPadding: const EdgeInsets.only(
                                  left: 12.0, right: 12.0),
                            );
                          },
                          groupNameController: controller,
                          child: TextField(
                            readOnly: true,
                            controller: controller,
                            cursorColor: GlobalProperties.shadowColor,
                            decoration: InputDecoration(
                              hintText: "Add Group",
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color: GlobalProperties.shadowColor),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color: GlobalProperties.shadowColor),
                              ),
                            ),
                          ),
                        ),
                      ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class NewCustomExpansionTile extends StatefulWidget {
  final IndexedWidgetBuilder itemBuilder;
  final int itemCount;
  final Widget child;
  final TextEditingController groupNameController;

  const NewCustomExpansionTile(
      {super.key,
      required this.itemCount,
      required this.groupNameController,
      required this.itemBuilder,
      required this.child});

  @override
  State<NewCustomExpansionTile> createState() => _NewCustomExpansionTileState();
}

class _NewCustomExpansionTileState extends State<NewCustomExpansionTile> {
  late bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () {
            setState(() {
              _isExpanded = !_isExpanded;
            });
          },
          child: AbsorbPointer(child: widget.child),
        ),
        Expanded(
          child: AnimatedFractionallySizedBox(
            heightFactor: !_isExpanded ? 0 : 1,
            alignment: Alignment.topCenter,
            duration: const Duration(milliseconds: 100),
            curve: Curves.fastOutSlowIn,
            child: ListView.separated(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                itemBuilder: widget.itemBuilder,
                separatorBuilder: (context, index) {
                  return Divider(
                    color: GlobalProperties.shadowColor,
                    height: 0,
                    indent: 0,
                    thickness: 1,
                  );
                },
                itemCount: widget.itemCount),
          ),
        ),
      ],
    );
  }
}
