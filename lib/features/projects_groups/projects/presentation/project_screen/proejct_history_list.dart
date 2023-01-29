import 'package:flutter/material.dart';

class ProjectHistory extends StatelessWidget {
  const ProjectHistory({super.key});

  List<Widget> _buildTmpHistoryChilds() {
    List<Widget> childs = [];

    for (int i = 0; i <= 20; i++) {
      childs.add(ListTile(
        title: Text("Tile$i"),
      ));
    }
    return childs;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(children: _buildTmpHistoryChilds()),
    );
  }
}
