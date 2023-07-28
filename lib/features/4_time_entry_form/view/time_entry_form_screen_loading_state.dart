import 'package:my_time/common/common.dart';
import 'package:my_time/constants/constants.dart';

import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class LabeldDateFormFieldLoadingState extends StatelessWidget {
  final double? height;
  final double? textWidth;

  const LabeldDateFormFieldLoadingState(
      {super.key, this.height, this.textWidth});

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

class TextAndContainer extends StatelessWidget {
  final double? width;
  final double? textWidth;
  final double? height;
  const TextAndContainer({super.key, this.width, this.height, this.textWidth});

  @override
  Widget build(BuildContext context) {
    final finalHeight = height ?? gapH48.height;
    final finalWidth = width ?? double.infinity;
    final finalTextWidth = textWidth ?? 50;
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(5)),
          child: Container(
            color: Colors.grey,
            height: gapH24.height,
            width: finalTextWidth,
          ),
        ),
        const Padding(padding: EdgeInsets.only(bottom: 12)),
        ResponsiveAlign(
          maxContentWidth: finalWidth,
          child: ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(5)),
            child: Container(
              color: Colors.grey,
              height: finalHeight,
            ),
          ),
        ),
      ],
    );
  }
}

class LabeldTimeFieldsLoadingsState extends StatelessWidget {
  const LabeldTimeFieldsLoadingsState({super.key});

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

class TimeEntryFormScreenLoadingState extends StatelessWidget {
  const TimeEntryFormScreenLoadingState({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      period: const Duration(seconds: 1),
      direction: ShimmerDirection.ltr,
      baseColor: Colors.grey[300] as Color,
      highlightColor: Colors.grey[200]!,
      child: ResponsiveAlign(
        alignment: Alignment.topCenter,
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
        child: CustomScrollView(
          slivers: [
            SliverFillRemaining(
              hasScrollBody: false,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const LabeldDateFormFieldLoadingState(),
                  const Padding(padding: EdgeInsets.only(bottom: 16)),
                  const LabeldTimeFieldsLoadingsState(),
                  const Padding(padding: EdgeInsets.only(bottom: 16)),
                  const LabeldDateFormFieldLoadingState(
                    textWidth: 85,
                    height: 240,
                  ),
                  Expanded(
                    child: NavBarSubmitButton(
                      isLoading: false,
                      btnText: "",
                      onBtnTap: () {},
                      align: Alignment.bottomCenter,
                      padding: const EdgeInsets.all(0),
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
