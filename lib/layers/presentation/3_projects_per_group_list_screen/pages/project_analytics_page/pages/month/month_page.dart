
import 'package:flutter/material.dart';

class MonthPage extends StatelessWidget {
  const MonthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 50,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text('Month List Tile $index'),
        );
      },
    );
  }
}