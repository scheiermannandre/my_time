import 'package:flutter/material.dart';

/// Shell for the MonthPage
class MonthPage extends StatefulWidget {
  /// Creates a MonthPage.
  const MonthPage({super.key});
  @override
  State<MonthPage> createState() => _MonthPageState();
}

class _MonthPageState extends State<MonthPage> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      key: UniqueKey(),
      itemCount: 50,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text('Month List Tile $index'),
        );
      },
    );
  }
}
