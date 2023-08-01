import 'package:flutter/material.dart';
import 'package:my_time/common/common.dart';
import 'package:my_time/features/4_time_entry_form/4_time_entry_form.dart';
import 'package:shimmer/shimmer.dart';

/// The loading state of the TimeEntryFormScreen.
class TimeEntryFormScreenLoadingState extends StatelessWidget {
  /// Creates a TimeEntryFormScreenLoadingState.
  const TimeEntryFormScreenLoadingState({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      period: const Duration(seconds: 1),
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[200]!,
      child: ResponsiveAlign(
        alignment: Alignment.topCenter,
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
        child: CustomScrollView(
          slivers: [
            SliverFillRemaining(
              hasScrollBody: false,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const LabeledDateFormFieldLoadingState(),
                  const Padding(padding: EdgeInsets.only(bottom: 16)),
                  const LabeledTimeFieldLoadingsState(),
                  const Padding(padding: EdgeInsets.only(bottom: 16)),
                  const LabeledDateFormFieldLoadingState(
                    textWidth: 85,
                    height: 240,
                  ),
                  Expanded(
                    child: NavBarSubmitButton(
                      isLoading: false,
                      btnText: '',
                      onBtnTap: () {},
                      align: Alignment.bottomCenter,
                      padding: EdgeInsets.zero,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
