import 'package:flutter/material.dart';

///
/// This is the custom TabItem widget
/// Used to display custom tabs for the pages per day/week/month/year TabView inside the PageAnalyticsPage.
/// Takes a list of widgets as children and shows them in a column.
class TabItem extends StatelessWidget {
  /// Constructor for the [TabItem].
  const TabItem({
    required this.children,
    super.key,
  });

  /// List of widgets to display.
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 44, right: 44),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          ...children, // Add the custom children
        ],
      ),
    );
  }
}
