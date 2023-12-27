import 'package:flutter/material.dart';
import 'package:my_time/foundation/config/theme/tokens/space_tokens.dart';
import 'package:my_time/foundation/core/widgets/spaced_column.dart';
import 'package:my_time/foundation/core/widgets/wizard/labeled_widgets.dart';
import 'package:my_time/foundation/core/widgets/wizard/wizard_review_step/wizard_review_step_wrapper.dart';

/// Review Card to demonstrate Data in the Review Steps
class ReviewDataCard<T> extends StatefulWidget {
  /// Constructor for the ReviewCard widget.
  const ReviewDataCard({
    required this.stepToJumpTo,
    required this.builder,
    required this.label,
    required this.evaluateVisibility,
    super.key,
  });

  /// The step to jump to when the card is clicked.
  final int stepToJumpTo;

  /// The builder for the content of the card.
  final List<Widget> Function(T?) builder;

  /// The label of the card.
  final String label;

  /// The function to evaluate the visibility of the card.
  final bool Function(T? data) evaluateVisibility;

  @override
  State<ReviewDataCard<T>> createState() => _ReviewDataCardState<T>();
}

class _ReviewDataCardState<T> extends State<ReviewDataCard<T>> {
  bool _isVisible = false;

  void postFrameCallback(T? data) {
    if (data == null) return;
    if (!mounted) return;
    final isVisible = widget.evaluateVisibility(data);
    if (_isVisible == isVisible) return;
    setState(() {
      _isVisible = isVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: _isVisible ? null : 0,
      height: _isVisible ? null : 0,
      child: LabeledWidgets(
        label: widget.label,
        children: [
          WizardReviewStepWrapper<T?>(
            stepToJumpTo: widget.stepToJumpTo,
            builder: (data) {
              WidgetsBinding.instance
                  .addPostFrameCallback((_) => postFrameCallback(data));
              return Visibility(
                visible: data != null,
                child: SingleChildScrollView(
                  child: SpacedColumn(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: SpaceTokens.mediumSmall,
                    children: widget.builder(data),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

/// Review Card to demonstrate Data in the Review Steps
class AccumulatedDataCard extends StatefulWidget {
  /// Constructor for the ReviewCard widget.
  const AccumulatedDataCard({
    required this.steps,
    required this.builder,
    required this.label,
    required this.evaluateVisibility,
    super.key,
  });

  /// The step to jump to when the card is clicked.
  final List<int> steps;

  /// The builder for the content of the card.
  final List<Widget> Function(Map<int, dynamic>) builder;

  /// The label of the card.
  final String label;

  /// The function to evaluate the visibility of the card.
  final bool Function(Map<int, dynamic>) evaluateVisibility;

  @override
  State<AccumulatedDataCard> createState() => _AccumulatedDataCardState();
}

class _AccumulatedDataCardState extends State<AccumulatedDataCard> {
  bool _isVisible = false;

  void postFrameCallback(Map<int, dynamic> data) {
    if (data.isEmpty) return;
    if (!mounted) return;
    final isVisible = widget.evaluateVisibility(data);
    if (_isVisible == isVisible) return;
    setState(() {
      _isVisible = isVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: _isVisible ? null : 0,
      height: _isVisible ? null : 0,
      child: LabeledWidgets(
        label: widget.label,
        children: [
          WizardReviewStepAccumulatedWrapper(
            steps: widget.steps,
            builder: (data) {
              WidgetsBinding.instance
                  .addPostFrameCallback((_) => postFrameCallback(data));
              return Visibility(
                visible: data.isNotEmpty,
                child: SingleChildScrollView(
                  child: SpacedColumn(
                    spacing: SpaceTokens.mediumSmall,
                    children: widget.builder(data),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

/// Review Card to demonstrate Data in the Review Steps that is not gathered
/// by the wizard
class DataCard extends StatelessWidget {
  /// Constructor for the ReviewCard widget.
  const DataCard({
    required this.children,
    required this.label,
    required this.isVisible,
    super.key,
  });

  /// The builder for the content of the card.
  final List<Widget> children;

  /// The label of the card.
  final String label;

  /// If the card is visible.
  final bool isVisible;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: isVisible ? null : 0,
      height: isVisible ? null : 0,
      child: LabeledWidgets(
        label: label,
        children: [
          WizardReviewStepDataWrapper(
            builder: () {
              return Visibility(
                visible: isVisible,
                child: SingleChildScrollView(
                  child: SpacedColumn(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: SpaceTokens.mediumSmall,
                    children: children,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
