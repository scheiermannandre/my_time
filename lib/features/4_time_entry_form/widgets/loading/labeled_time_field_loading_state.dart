import 'package:flutter/material.dart';
import 'package:my_time/common/common.dart';
import 'package:my_time/constants/constants.dart';
import 'package:my_time/features/4_time_entry_form/4_time_entry_form.dart';

/// The loading state of the LabeledTimeFields.
class LabeledTimeFieldLoadingsState extends StatelessWidget {
  /// Creates a LabeledTimeFieldLoadingsState.
  const LabeledTimeFieldLoadingsState({super.key});

  @override
  Widget build(BuildContext context) {
    return const ResponsiveAlign(
      maxContentWidth: Breakpoint.tablet,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextAndContainer(
            width: 100,
          ),
          TextAndContainer(
            width: 100,
          ),
          TextAndContainer(
            width: 100,
          ),
        ],
      ),
    );
  }
}
