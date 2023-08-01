import 'package:flutter/material.dart';
import 'package:my_time/constants/constants.dart';
import 'package:shimmer/shimmer.dart';

/// Widget for the project timer shell page loading state.
class ProjectTimerShellPageLoadingState extends StatelessWidget {
  /// Creates a [ProjectTimerShellPageLoadingState].
  const ProjectTimerShellPageLoadingState({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      period: const Duration(seconds: 1),
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[200]!,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
            alignment: Alignment.center,
            height: 250,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              shape: BoxShape.circle,
            ),
          ),
          ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(5)),
            child: Container(
              color: Colors.grey,
              height: gapH52.height,
              width: Breakpoint.mobile,
            ),
          )
        ],
      ),
    );
  }
}
