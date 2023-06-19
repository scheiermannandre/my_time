import 'package:flutter/material.dart';

///
/// Shell for the DayPage
class DayPage extends StatefulWidget {
  const DayPage({super.key});
  @override
  State<DayPage> createState() => _DayPageState();
}

class _DayPageState extends State<DayPage> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      key: UniqueKey(),
      itemCount: 50,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text('Day List Tile $index'),
        );
      },
    );
  }
}
