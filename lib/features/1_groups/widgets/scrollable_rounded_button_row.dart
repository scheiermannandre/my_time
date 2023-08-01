import 'package:flutter/material.dart';
import 'package:my_time/features/1_groups/1_groups.dart';

/// A Scrollable Row of [RoundedLabeldButton].
class ScrollableRoundedButtonRow extends StatelessWidget {
  /// Creates a [ScrollableRoundedButtonRow].
  const ScrollableRoundedButtonRow({
    required this.children,
    super.key,
    this.padding = const EdgeInsets.fromLTRB(2.5, 0, 2.5, 0),
  });

  /// Children of the row.
  final List<RoundedLabeldButton> children;

  /// Padding of the row.
  final EdgeInsets padding;

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
          children.length,
          (index) => _itemBuilder(context, index),
        ).toList(),
      ),
    );
  }
}
