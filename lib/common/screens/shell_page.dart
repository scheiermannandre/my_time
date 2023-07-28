import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

abstract class ShellPage extends HookConsumerWidget {
  const ShellPage({
    required this.iconData,
    required this.label,
    super.key,
  });
  final IconData iconData;
  final String label;
}
