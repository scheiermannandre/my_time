import 'package:flutter/material.dart';
import 'package:my_time/common/widgets/responsive_center.dart';
import 'package:my_time/constants/app_sizes.dart';
import 'package:my_time/global/globals.dart';
import 'package:shimmer/shimmer.dart';

class ProjectHistoryListLoadingState extends StatelessWidget {
  const ProjectHistoryListLoadingState({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      period: const Duration(seconds: 1),
      direction: ShimmerDirection.ltr,
      baseColor: Colors.grey[300] as Color,
      highlightColor: Colors.grey[200]!,
      child: SingleChildScrollView(
        child: ListView.builder(
          itemCount: 3,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            return const LabeledBlockLoadingState();
          },
        ),
      ),
    );
  }
}

class LabeledBlockLoadingState extends StatelessWidget {
  const LabeledBlockLoadingState({super.key});
  @override
  Widget build(BuildContext context) {
    return ResponsiveAlign(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(5)),
            child: Container(
              color: Colors.grey,
              width: 200,
              height: gapH28.height,
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(bottom: 12),
          ),
          ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(5)),
            child: Container(
              color: Colors.grey,
              child: ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: 2,
                itemBuilder: (context, index) => ResponsiveAlign(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("", style: TextStyle(fontSize: 18)),
                          const Padding(
                              padding: EdgeInsets.fromLTRB(0, 8, 0, 0)),
                          Row(
                            children: const [
                              Text(
                                "",
                              ),
                              Text(
                                " - ",
                              ),
                              Text(
                                "",
                              ),
                            ],
                          )
                        ],
                      ),
                      const Text(
                        "",
                      ),
                    ],
                  ),
                ),
                separatorBuilder: (context, index) => Divider(
                  color: GlobalProperties.shadowColor,
                  height: 1,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
