import 'package:my_time/common/common.dart';

import 'package:flutter/material.dart';

abstract class ProjectShellPage extends ShellPage {
  const ProjectShellPage(
      {super.key,
      required super.iconData,
      required super.label,
      this.scrollController});
  final ScrollController? scrollController;

  ProjectShellPage copyWith({
    required ScrollController controller,
  });
}
