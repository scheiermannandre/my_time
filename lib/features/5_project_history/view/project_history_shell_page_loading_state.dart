import 'package:flutter/material.dart';
import 'package:my_time/features/5_project_history/5_project_history.dart';
import 'package:shimmer/shimmer.dart';

/// The loading state of the ProjectHistoryShellPage.
class ProjectHistoryShellPageLoadingState extends StatelessWidget {
  /// Creates a ProjectHistoryShellPageLoadingState.
  const ProjectHistoryShellPageLoadingState({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      period: const Duration(seconds: 1),
      baseColor: Colors.grey[300]!,
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
