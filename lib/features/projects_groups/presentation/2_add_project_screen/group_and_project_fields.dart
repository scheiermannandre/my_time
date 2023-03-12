
import 'package:flutter/material.dart';
import 'package:my_time/common/widgets/custom_expansion_tile.dart';
import 'package:my_time/common/widgets/responsive_center.dart';
import 'package:my_time/features/projects_groups/domain/group.dart';
import 'package:my_time/features/projects_groups/presentation/2_add_project_screen/group_selection_field.dart';
import 'package:my_time/features/projects_groups/presentation/2_add_project_screen/project_name_field.dart';

class GroupAndProjectFields extends StatelessWidget {
  const GroupAndProjectFields(
      {super.key,
      this.expansionTile,
      required this.selectedGroup,
      this.isExpandable = false,
      this.onListTileTap,
      required this.controller,
      required this.groups});
  final GlobalKey<CustomExpansionTileState>? expansionTile;
  final String selectedGroup;
  final bool isExpandable;
  final Function(List<Group>, int)? onListTileTap;
  final TextEditingController controller;
  final List<Group> groups;
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
