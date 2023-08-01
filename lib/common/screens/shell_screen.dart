import 'package:flutter/material.dart';
import 'package:my_time/common/common.dart';

/// Base screen for shell pages.
class ShellScreen extends StatelessWidget {
  /// Creates a [ShellScreen].
  const ShellScreen({required List<ShellPage> children, super.key})
      : _children = children;

  final List<ShellPage> _children;
  @override
  Widget build(BuildContext context) {
    return ShellScreenScaffold(children: _children);
  }
}
