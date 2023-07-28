import 'package:my_time/common/common.dart';

import 'package:flutter/material.dart';

class ShellScreen extends StatelessWidget {
  const ShellScreen({super.key, required this.children});
  final List<ShellPage> children;
  @override
  Widget build(BuildContext context) {
    return ShellScreenScaffold(children: children);
  }
}
