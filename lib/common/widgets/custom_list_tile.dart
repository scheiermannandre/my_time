import 'package:flutter/material.dart';
import 'package:my_time/global/globals.dart';

/// Custom list for displaying groups and projects.
class CustomListTile extends StatefulWidget {
  /// Creates a [CustomListTile].
  const CustomListTile({required this.title, super.key, this.onTap});

  /// Title of the list tile.
  final String title;

  /// Function to call when the list tile is tapped.
  final void Function()? onTap;

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
            blurRadius: 1, // soften the sha,dow
          ),
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
        onTap: widget.onTap,
        child: Container(
          padding: const EdgeInsets.fromLTRB(12, 18, 12, 18),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.background,
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(4),
              bottom: Radius.circular(4),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.title,
                style: Theme.of(context).textTheme.titleLarge,
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
