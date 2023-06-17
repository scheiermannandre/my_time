import 'package:flutter/material.dart';

class YearPage extends StatelessWidget {
  const YearPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 50,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text('Year List Tile $index'),
        );
      },
    );
  }
}