import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_time/common/widgets/appbar/screen_sliver_appbar.dart';
import 'package:my_time/common/widgets/async_value_widget.dart';
import 'package:my_time/common/widgets/responsive_center.dart';
import 'package:my_time/features/projects_groups/groups/data/groups_repository.dart';
import 'package:my_time/features/projects_groups/groups/presentation/groups_screen/header_with_button.dart';
import 'package:my_time/global/globals.dart';
import 'package:my_time/common/widgets/dissmissible_tile/dissmissible_tile.dart';

class GroupsScreen extends StatefulWidget {
  const GroupsScreen({super.key});

  @override
  State<GroupsScreen> createState() => _GroupsScreenState();
}

class _GroupsScreenState extends State<GroupsScreen>
    with TickerProviderStateMixin {
  TextEditingController controller = TextEditingController();

  bool addGroup = false;
  EdgeInsets padding = const EdgeInsets.fromLTRB(10, 10, 10, 10);

  final String buttonTextAdd = "Add Group";
  final String buttonTextSave = "Save";
  late String headerButtonText;

  @override
  initState() {
    super.initState();
    headerButtonText = "Add Group";
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GlobalProperties.backgroundColor,
      body: CustomScrollView(
        slivers: <Widget>[
          ScreenSliverAppBar(
            title: 'Groups',
          ),
          ResponsiveSliverAlign(
            padding: padding,
            child: HeaderWithButton(
              title: "Groups",
              buttonText: headerButtonText,
              onButtonPressed: () {
                setState(() {
                  addGroup = !addGroup;
                  headerButtonText == buttonTextAdd
                      ? headerButtonText = buttonTextSave
                      : headerButtonText = buttonTextAdd;
                });
              },
            ),
          ),
          ResponsiveSliverAlign(
            padding: padding,
            child: SingleChildScrollView(
              physics: const ScrollPhysics(),
              child: Consumer(
                builder: (context, ref, child) {
                  final groupsListValue = ref.watch(groupsListStreamProvider);
                  return AsyncValueWidget(
                    value: groupsListValue,
                    data: (groups) => groups.isEmpty
                        ? Center(
                            child: Text(
                              'No groups found',
                              style: Theme.of(context).textTheme.headline4,
                            ),
                          )
                        : Column(
                            children: [
                              addGroup
                                  ? ResponsiveAlign(
                                      padding: const EdgeInsets.only(
                                          top: 5, bottom: 5),
                                      child: DismissibleTile(
                                        title: Random()
                                            .nextInt(10000000)
                                            .toString(),
                                        widget: TextFormField(
                                          controller: controller,
                                          cursorColor: GlobalProperties
                                              .secondaryAccentColor,
                                          decoration: const InputDecoration(
                                            border: InputBorder.none,
                                            contentPadding: EdgeInsets.zero,
                                            hintText: "Add new Group",
                                          ),
                                        ),
                                        onDeleted: (name) {
                                          setState(() {
                                            addGroup = false;
                                          });
                                        },
                                      ),
                                    )
                                  : const SizedBox.shrink(),
                              ListView.builder(
                                padding: EdgeInsets.zero,
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: groups.length,
                                itemBuilder: (context, index) {
                                  return ResponsiveAlign(
                                    padding: const EdgeInsets.only(
                                        top: 5, bottom: 5),
                                    child: DismissibleTile(
                                      title: groups[index].name,
                                      widget: Text(
                                        groups[index].name,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.normal,
                                            fontSize: 18),
                                      ),
                                      onDeleted: (title) {
                                        setState(() {});
                                      },
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
