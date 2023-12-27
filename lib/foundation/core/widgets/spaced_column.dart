import 'package:flutter/material.dart';

/// A column widget with customizable spacing between its children.
///
/// The `SpacedColumn` widget arranges its children in a column layout
/// with specified spacing between each child.
class SpacedColumn extends StatelessWidget {
  /// Creates a `SpacedColumn` widget.
  ///
  /// The [children] parameter is a list of widgets to be displayed
  /// in the column.
  /// The [spacing] parameter is the vertical space between each child.
  /// The [crossAxisAlignment] parameter controls how the children are placed
  /// along the cross axis in the column.
  /// The [mainAxisAlignment] parameter controls how the children are placed
  /// along the main axis in the column.
  const SpacedColumn({
    required this.children,
    super.key,
    this.spacing = 0.0,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.mainAxisAlignment = MainAxisAlignment.start,
  });

  /// The list of widgets to be displayed in the column.
  final List<Widget> children;

  /// The vertical space between each child in the column.
  final double spacing;

  /// How the children are placed along the cross axis in the column.
  final CrossAxisAlignment crossAxisAlignment;

  /// How the children are placed along the main axis in the column.
  final MainAxisAlignment mainAxisAlignment;

  /// Builds the column by interspersing [spacing] between the children.
  ///
  /// This method generates a new list of widgets where spacing is added
  /// between each child. The actual children are at odd indices in
  /// the new list.
  Widget _builder(BuildContext context, int index) {
    if (index.isOdd) {
      return SizedBox(height: spacing);
    }

    final realIndex = index ~/ 2;
    return children[realIndex];
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: crossAxisAlignment,
      mainAxisAlignment: mainAxisAlignment,
      children: List.generate(
        (children.length * 2) - 1,
        (index) => _builder(context, index),
      ),
    );
  }
}
