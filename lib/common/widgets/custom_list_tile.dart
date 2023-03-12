import 'package:flutter/material.dart';
import 'package:my_time/global/globals.dart';

class CustomListTile extends StatefulWidget {
  final String title;
  final Function? onTap;
  const CustomListTile({super.key, required this.title, this.onTap});

  @override
  State<CustomListTile> createState() => _CustomListTileState();
}

class _CustomListTileState extends State<CustomListTile> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: GlobalProperties.shadowColor,
            blurRadius: 1.0, // soften the shadow
            spreadRadius: 0.0, //extend the shadow
          )
        ],
        color: Colors.white,
        border: Border.all(
          color: GlobalProperties.shadowColor,
          strokeAlign: BorderSide.strokeAlignOutside,
        ),
        borderRadius: const BorderRadius.all(
          Radius.circular(5),
        ),
      ),
      child: InkWell(
        onTap: () {
          if (widget.onTap != null) {
            widget.onTap!();
          }
        },
        child: Container(
          padding: const EdgeInsets.fromLTRB(12, 18, 12, 18),
          decoration: const BoxDecoration(
            color: GlobalProperties.backgroundColor,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(4),
              bottom: Radius.circular(4),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.title,
                style: const TextStyle(
                    fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const RotatedBox(
                quarterTurns: 3,
                child: Icon(
                  Icons.expand_more,
                  size: 24,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
