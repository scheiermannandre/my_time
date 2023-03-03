import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_time/common/widgets/async_value_widget.dart';
import 'package:my_time/common/widgets/custom_expansion_tile.dart';
import 'package:my_time/common/widgets/responsive_center.dart';
import 'package:my_time/features/projects_groups/data/groups_repository.dart';
import 'package:my_time/features/projects_groups/domain/group.dart';
import 'package:my_time/global/globals.dart';

class GroupSelectionField extends StatefulWidget {
  late String selectedGroup;
  final bool isExpandable;
  final Function(String selectedValue) onSelectionChanged;
  GroupSelectionField(
      {super.key,
      required this.selectedGroup,
      required this.isExpandable,
      required this.onSelectionChanged});

  @override
  State<GroupSelectionField> createState() => _GroupSelectionFieldState();
}

class _GroupSelectionFieldState extends State<GroupSelectionField> {
  final GlobalKey<CustomExpansionTileState> expansionTile = GlobalKey();

  void onListTileTap(List<Group> groups, int index) {
    widget.onSelectionChanged(groups[index].name);
    setState(() {
      widget.selectedGroup = groups[index].name;
      expansionTile.currentState!.collapse();
    });
  }

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
        Consumer(
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
                      padding: const EdgeInsets.only(top: 0, bottom: 5),
                      child: CustomExpansionTile(
                        contentPadding: const EdgeInsets.only(bottom: 8),
                        decoration: BoxDecoration(
                          border: Border(
                            bottom:
                                BorderSide(color: GlobalProperties.shadowColor),
                          ),
                        ),
                        isExpandable: widget.isExpandable,
                        onExpansionChanged: (value) {},
                        key: expansionTile,
                        title: Text(widget.selectedGroup),
                        children: <Widget>[
                          ListView.separated(
                              padding: EdgeInsets.zero,
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                return ListTile(
                                  title: Text(groups[index].name),
                                  onTap: () => onListTileTap(groups, index),
                                  contentPadding: const EdgeInsets.only(
                                      left: 12.0, right: 12.0),
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
                              itemCount: groups.length),
                        ],
                      ),
                    ),
            );
          },
        ),
      ],
    );
  }
}
