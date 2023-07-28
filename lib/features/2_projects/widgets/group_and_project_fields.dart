import 'package:my_time/common/common.dart';
import 'package:my_time/features/2_projects/2_projects.dart';

import 'package:flutter/material.dart';

class GroupAndProjectFields extends StatelessWidget {
  const GroupAndProjectFields(
      {super.key,
      this.expansionTile,
      required this.selectedGroup,
      this.isExpandable = false,
      this.onListTileTap,
      required this.controller,
      required this.groups,
      required this.defaultSelectedGroup});
  final GlobalKey<CustomExpansionTileState>? expansionTile;
  final String? selectedGroup;
  final String defaultSelectedGroup;

  final bool isExpandable;
  final Function(List<GroupModel>, int)? onListTileTap;
  final TextEditingController controller;
  final List<GroupModel> groups;
  @override
  Widget build(BuildContext context) {
    return ResponsiveAlign(
      alignment: Alignment.topCenter,
      padding: const EdgeInsets.fromLTRB(16, 30, 16, 0),
      child: SingleChildScrollView(
        child: Column(
          children: [
            GroupSelectionField(
                groups: groups,
                expansionTile: expansionTile,
                selectedGroup: selectedGroup,
                defaultSelectedGroup: defaultSelectedGroup,
                isExpandable: isExpandable,
                onListTileTap: (groups, index) => {
                      if (onListTileTap != null) {onListTileTap!(groups, index)}
                    }),
            const Padding(padding: EdgeInsets.only(bottom: 10)),
            ProjectNameField(
              projectNameController: controller,
            ),
          ],
        ),
      ),
    );
  }
}
