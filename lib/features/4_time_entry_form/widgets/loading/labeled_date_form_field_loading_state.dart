import 'package:flutter/material.dart';
import 'package:my_time/common/common.dart';
import 'package:my_time/constants/constants.dart';
import 'package:my_time/features/4_time_entry_form/4_time_entry_form.dart';

/// The loading state of the LabeledDateFormField.
class LabeledDateFormFieldLoadingState extends StatelessWidget {
  /// Creates a LabeledDateFormFieldLoadingState.
  const LabeledDateFormFieldLoadingState({
    super.key,
    this.height,
    this.textWidth,
  });

  /// The height of the container.
  final double? height;

  /// The width of the text.
  final double? textWidth;

  @override
  Widget build(BuildContext context) {
    return ResponsiveAlign(
      maxContentWidth: Breakpoint.tablet,
      child: TextAndContainer(
        height: height,
        textWidth: textWidth,
      ),
    );
  }
}
