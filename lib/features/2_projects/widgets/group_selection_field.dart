import 'package:flutter/material.dart';
import 'package:my_time/common/common.dart';
import 'package:my_time/features/2_projects/2_projects.dart';
import 'package:my_time/global/globals.dart';

/// The field for the group selection.
class GroupSelectionField extends StatelessWidget {
  /// Creates a [GroupSelectionField].
  const GroupSelectionField({
    required this.selectedGroup,
    required this.isExpandable,
    required this.expansionTile,
    required this.onListTileTap,
    required this.groups,
    required this.defaultSelectedGroup,
    super.key,
  });

  /// The selected group.
  final String? selectedGroup;

  /// The default selected group.
  final String defaultSelectedGroup;

  /// Indicates if the group selection field is expandable.
  final bool isExpandable;

  /// The expansion tile of the group selection field.
  final GlobalKey<CustomExpansionTileState>? expansionTile;

  /// Groups that are shown in the dropdown.
  final List<GroupModel> groups;

  /// Callback for the tap on a list tile.
  final void Function(List<GroupModel> groups, int index)? onListTileTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Text(
            context.loc.addProjectScreenGroupFieldLabel,
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
        ResponsiveAlign(
          padding: const EdgeInsets.only(bottom: 5),
          child: CustomExpansionTile(
            contentPadding: const EdgeInsets.only(bottom: 8),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: GlobalProperties.shadowColor),
              ),
            ),
            isExpandable: isExpandable,
            onExpansionChanged: (value) {},
            key: expansionTile,
            title: Text(selectedGroup ?? defaultSelectedGroup),
            children: <Widget>[
              ListView.separated(
                padding: EdgeInsets.zero,
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(groups[index].name),
                    onTap: () => {
                      if (onListTileTap != null) {onListTileTap!(groups, index)}
                    },
                    contentPadding: const EdgeInsets.only(left: 12, right: 12),
                  );
                },
                separatorBuilder: (context, index) {
                  return Divider(
                    color: GlobalProperties.shadowColor,
                    height: 0,
                    indent: 0,
                    thickness: 1,
                  );
                },
                itemCount: groups.length,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
