import 'package:flutter/material.dart';
import 'package:my_time/common/common.dart';
import 'package:my_time/features/2_projects/2_projects.dart';

/// The fields for the group and project name.
class GroupAndProjectFields extends StatelessWidget {
  /// Creates a [GroupAndProjectFields].
  const GroupAndProjectFields({
    required this.selectedGroup,
    required this.controller,
    required this.groups,
    required this.defaultSelectedGroup,
    super.key,
    this.expansionTile,
    this.isExpandable = false,
    this.onListTileTap,
  });

  /// The expansion tile of the group selection field.
  final GlobalKey<CustomExpansionTileState>? expansionTile;

  /// The selected group.
  final String? selectedGroup;

  /// The default selected group.
  final String defaultSelectedGroup;

  /// Indicates if the group selection field is expandable.
  final bool isExpandable;

  /// Callback for the tap on a list tile.
  final void Function(List<GroupModel>, int)? onListTileTap;

  /// The controller for the project name field.
  final TextEditingController controller;

  /// The groups.
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
                if (onListTileTap != null) {onListTileTap!(groups, index)},
              },
            ),
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
