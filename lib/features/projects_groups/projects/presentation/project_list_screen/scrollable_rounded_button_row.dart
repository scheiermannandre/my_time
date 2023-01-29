import 'package:flutter/material.dart';
import 'package:my_time/features/projects_groups/projects/presentation/project_list_screen/rounded_labeled_button.dart';

class ScrollableRoundendButtonRow extends StatelessWidget {
  final List<RoundedLabeldButton> children;
  final EdgeInsets padding;
  const ScrollableRoundendButtonRow(
      {super.key,
      required this.children,
      this.padding = const EdgeInsets.fromLTRB(2.5, 0, 2.5, 0)});

  Widget _itemBuilder(BuildContext context, int index) {
    return Padding(padding: padding, child: children[index]);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List<Widget>.generate(
            children.length, (index) => _itemBuilder(context, index)).toList(),
      ),
    );
  }
}
