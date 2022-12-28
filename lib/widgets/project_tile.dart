import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class ProjectTile extends StatelessWidget {
  late String title;
  ProjectTile({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text(title),
      color: Colors.yellow,
    );
  }
}

// class ProjectTile extends StatefulWidget {
//   const ProjectTile({super.key});

//   @override
//   State<ProjectTile> createState() => _ProjectTileState();
// }

// class _ProjectTileState extends State<ProjectTile> {
//   @override
//   Widget build(BuildContext context) {
//     return Container(      color: Colors.yellow,
// );
//   }
// }