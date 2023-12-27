import 'package:flutter/material.dart';

/// A row widget with customizable spacing between its children.
///
/// The `SpacedRow` widget arranges its children in a row layout
/// with specified spacing between each child.
class SpacedRow extends StatelessWidget {
  /// Creates a `SpacedRow` widget.
  ///
  /// The [children] parameter is a list of widgets to be displayed in the row.
  /// The [spacing] parameter is the horizontal space between each child.
  /// The [crossAxisAlignment] parameter controls how the children are placed
  /// along the cross axis in the row.
  /// The [mainAxisAlignment] parameter controls how the children are placed
  /// along the main axis in the row.
  const SpacedRow({
    required this.children,
    super.key,
    this.spacing = 0.0,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.mainAxisAlignment = MainAxisAlignment.start,
  });

  /// The list of widgets to be displayed in the row.
  final List<Widget> children;

  /// The horizontal space between each child in the row.
  final double spacing;

  /// How the children are placed along the cross axis in the row.
  final CrossAxisAlignment crossAxisAlignment;

  /// How the children are placed along the main axis in the row.
  final MainAxisAlignment mainAxisAlignment;

  /// Builds the row by interspersing [spacing] between the children.
  ///
  /// This method generates a new list of widgets where spacing is added
  /// between each child. The actual children are at odd indices in the
  /// new list.
  Widget builder(BuildContext context, int index) {
    if (index.isOdd) {
      return SizedBox(width: spacing);
    }

    final realIndex = index ~/ 2;
    return children[realIndex];
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: crossAxisAlignment,
      mainAxisAlignment: mainAxisAlignment,
      children: List.generate(
        (children.length * 2) - 1,
        (index) => builder(context, index),
      ),
    );
  }
}
