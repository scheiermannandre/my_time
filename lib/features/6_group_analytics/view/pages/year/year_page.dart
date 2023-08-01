import 'package:flutter/material.dart';

/// Shell for the YearPage
class YearPage extends StatefulWidget {
  /// Creates a YearPage.
  const YearPage({super.key});

  @override
  State<YearPage> createState() => _YearPageState();
}

class _YearPageState extends State<YearPage> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      key: UniqueKey(),
      itemBuilder: (context, index) {
        return ListTile(
          title: Text('Year List Tile $index'),
        );
      },
    );
  }
}
