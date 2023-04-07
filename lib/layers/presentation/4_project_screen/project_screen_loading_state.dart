import 'package:flutter/material.dart';
import 'package:my_time/constants/app_sizes.dart';
import 'package:my_time/constants/breakpoints.dart';
import 'package:my_time/global/globals.dart';
import 'package:shimmer/shimmer.dart';

class ProjectScreenLoadingState extends StatelessWidget {
  const ProjectScreenLoadingState({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      period: const Duration(seconds: 1),
      direction: ShimmerDirection.ltr,
      baseColor: Colors.grey[300] as Color,
      highlightColor: Colors.grey[200]!,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            alignment: Alignment.center,
            height: 250,
            decoration: const BoxDecoration(
                color: GlobalProperties.secondaryAccentColor,
                shape: BoxShape.circle),
          ),
          ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(5)),
            child: Container(
              color: Colors.grey,
              height: gapH52.height!,
              width: Breakpoint.mobile,
            ),
          )
        ],
      ),
    );
  }
}
