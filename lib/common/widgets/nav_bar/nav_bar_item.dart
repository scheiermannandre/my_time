import 'package:flutter/material.dart';

/// NavBar item for the CustomNavBar.
class CustomNavBarItem {
  /// Creates a [CustomNavBarItem].
  CustomNavBarItem({required this.iconData, required this.label});

  /// Icon of the item.
  final IconData iconData;

  /// Label of the item.
  final String label;
}
