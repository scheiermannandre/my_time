import 'package:flutter/material.dart';

class WeekPage extends StatelessWidget {
  const WeekPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 50,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text('Week List Tile $index'),
        );
      },
    );
  }
}