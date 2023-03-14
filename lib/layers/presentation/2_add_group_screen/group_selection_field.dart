import 'package:flutter/material.dart';
import 'package:my_time/common/widgets/custom_expansion_tile.dart';
import 'package:my_time/common/widgets/responsive_center.dart';
import 'package:my_time/layers/interface/dto/group_dto.dart';
import 'package:my_time/global/globals.dart';

class GroupSelectionField extends StatelessWidget {
  final String selectedGroup;
  final bool isExpandable;
  final GlobalKey<CustomExpansionTileState>? expansionTile;
  final List<GroupDTO> groups;
  final Function(List<GroupDTO> groups, int index)? onListTileTap;
  const GroupSelectionField(
      {super.key,
      required this.selectedGroup,
      required this.isExpandable,
      required this.expansionTile,
      required this.onListTileTap,
      required this.groups});

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
        ResponsiveAlign(
          padding: const EdgeInsets.only(top: 0, bottom: 5),
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
            title: Text(selectedGroup),
            children: <Widget>[
              ListView.separated(
                  padding: EdgeInsets.zero,
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(groups[index].name),
                      onTap: () => {
                        if (onListTileTap != null)
                          {onListTileTap!(groups, index)}
                      },
                      contentPadding:
                          const EdgeInsets.only(left: 12.0, right: 12.0),
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
      ],
    );
  }
}
