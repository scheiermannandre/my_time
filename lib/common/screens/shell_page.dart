import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// Base class for all shell pages.
abstract class ShellPage extends HookConsumerWidget {
  /// Creates a [ShellPage].
  const ShellPage({
    // required this.iconData,
    // required this.label,
    super.key,
  });

  /// Icon of the page, that will be displayed in a NavBar oder TabBar.
  IconData getIconData();

  /// Label of the page, that will be displayed in a NavBar oder TabBar.
  String getLabel(BuildContext context);
}
