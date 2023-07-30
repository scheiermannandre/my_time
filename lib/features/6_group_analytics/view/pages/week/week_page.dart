import 'package:flutter/material.dart';

///
/// Shell for the WeekPage
class WeekPage extends StatefulWidget {
  const WeekPage({super.key});
  @override
  State<WeekPage> createState() => _WeekPageState();
}

class _WeekPageState extends State<WeekPage> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      key: UniqueKey(),
      itemCount: 50,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text('Week List Tile $index'),
        );
      },
    );
  }
}