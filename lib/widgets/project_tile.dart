import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:my_time/global/globals.dart';

class ProjectTile extends StatelessWidget {
  late String title;
  ProjectTile({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height * 0.075;
    double width = MediaQuery.of(context).size.width * 0.85;

    return Container(
      height: height,
      width: width,
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
      alignment: Alignment.centerLeft,
      decoration: BoxDecoration(
          boxShadow: const [
            BoxShadow(
              color: GlobalProperties.ShadowColor,
              blurRadius: 2.0, // soften the shadow
              spreadRadius: 0.0, //extend the shadow
              offset: Offset(
                0.0, // Move to right 5  horizontally
                0.0, // Move to bottom 5 Vertically
              ),
            )
          ],
          color: GlobalProperties.PrimaryColor,
          border: Border.all(color: Colors.transparent),
          borderRadius: const BorderRadius.all(Radius.circular(10))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [Text(title), const Icon(Icons.arrow_forward_ios)],
      ),
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