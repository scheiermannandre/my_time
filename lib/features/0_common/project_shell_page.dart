import 'package:flutter/material.dart';
import 'package:my_time/common/common.dart';

/// Base screen for the project shell pages.
abstract class ProjectShellPage extends ShellPage {
  /// Creates a [ProjectShellPage].
  const ProjectShellPage({
    super.key,
    this.scrollController,
  });

  /// Scroll controller of the page, so the CustomAppBar can dynamically change
  /// it's elevation.
  final ScrollController? scrollController;

  /// Creates a copy of this [ProjectShellPage] but with the given fields,
  /// so that the Widget itself is immutable.
  ProjectShellPage copyWith({
    required ScrollController controller,
  });
}
