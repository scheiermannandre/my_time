import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:my_time/config/theme/tokens/space_tokens.dart';
import 'package:my_time/core/widgets/action_button.dart';

/// A set of customizable buttons for a wizard-like interface.
///
/// The `WizardButtons` widget provides a collection of buttons commonly used
/// in a wizard or step-by-step interface. It includes buttons for navigation,
/// finishing, skipping, and reviewing steps.
class WizardButtons extends StatefulHookWidget {
  /// Creates a `WizardButtons` widget.
  ///
  /// The [previousButtonContent], [nextButtonContent],
  ///  [goToLastPageButtonContent],
  /// [finishButtonContent], and [skipButtonContent] are the contents of the
  /// respective buttons.
  ///
  /// The [onPrevious], [onNext], [onLastPage], [onFinish], and [onSkip]
  /// callbacks handle the button presses.
  ///
  /// Additional configurations such as spacing, skipability, and button
  /// enabling can be adjusted using various boolean flags and values.
  const WizardButtons({
    required this.previousButtonContent,
    required this.nextButtonContent,
    required this.goToLastPageButtonContent,
    required this.onFinish,
    required this.onPrevious,
    required this.onNext,
    required this.onLastPage,
    required this.finishButtonContent,
    required this.onSkip,
    required this.skipButtonContent,
    required this.isSkipable,
    required this.isNextBtnEnabled,
    required this.isLastStep,
    required this.isInReview,
    required this.isFirstStep,
    required this.showNextBtn,
    required this.isLoading,
    super.key,
    this.spacing = SpaceTokens.small,
  });

  /// The callback function to be invoked when the previous button is pressed.
  final VoidCallback onPrevious;

  /// The callback function to be invoked when the next button is pressed.
  final VoidCallback onNext;

  /// The callback function to be invoked when the last page button is pressed.
  final VoidCallback onLastPage;

  /// The callback function to be invoked when the finish button is pressed.
  final VoidCallback onFinish;

  /// The callback function to be invoked when the skip button is pressed.
  final VoidCallback onSkip;

  /// The content of the previous button.
  final Widget previousButtonContent;

  /// The content of the next button when it is in a primary state.
  final Widget nextButtonContent;

  /// The content of the last page button.
  final Widget goToLastPageButtonContent;

  /// The content of the finish button.
  final Widget finishButtonContent;

  /// The content of the skip button.
  final Widget skipButtonContent;

  /// The space between the buttons.
  final double spacing;

  /// Whether the skip button should be shown or hidden.
  final bool isSkipable;

  /// Whether the next button should be enabled or disabled.
  final bool isNextBtnEnabled;

  /// Whether the next button should be shown or hidden.
  final bool showNextBtn;

  /// Whether the current step is the last step.
  final bool isLastStep;

  /// Whether the current step is the first step.
  final bool isInReview;

  /// Whether the current step is the first step.
  final bool isFirstStep;

  /// Whether the current step is in a loading state.
  final bool isLoading;

  @override
  State<WizardButtons> createState() => _WizardButtonsState();
}

class _WizardButtonsState extends State<WizardButtons> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AnimatedButtonShell(
          axisAlignment: -1,
          button: ActionButton.secondary(
            onPressed: widget.onSkip,
            child: widget.skipButtonContent,
          ),
          showBtn: widget.isSkipable && !widget.isInReview,
        ),
        Visibility(
          visible: widget.isSkipable && !widget.isInReview,
          child: SizedBox(height: widget.spacing),
        ),
        LayoutBuilder(
          builder: (context, constraints) => AnimatedBtnRow(
            showrightBtn:
                (widget.showNextBtn || widget.isInReview) && !widget.isLastStep,
            showLeftBtn: !widget.isFirstStep,
            constraints: constraints,
            rightBtnTitle: widget.nextButtonContent,
            rightBtnIsPrimary: !widget.isInReview,
            leftBtnTitle: widget.previousButtonContent,
            leftBtnIsPrimary: false,
            onRightBtn: widget.isNextBtnEnabled ? widget.onNext : null,
            onLeftBtn: widget.onPrevious,
            gap: widget.spacing,
          ),
        ),
        Visibility(
          visible: widget.isInReview,
          child: SizedBox(height: widget.spacing),
        ),
        LayoutBuilder(
          builder: (context, constraints) => AnimatedBtnRow(
            constraints: constraints,
            gap: widget.spacing,
            showrightBtn: widget.isLastStep,
            rightBtnTitle: widget.finishButtonContent,
            rightBtnIsLoading: widget.isLoading,
            onRightBtn: widget.onFinish,
            showLeftBtn: !widget.isLastStep && widget.isInReview,
            leftBtnTitle: widget.goToLastPageButtonContent,
            onLeftBtn: widget.onLastPage,
          ),
        ),
      ],
    );
  }
}

class _Sizes {
  const _Sizes(this.nBegin, this.nEnd, this.pBegin, this.pEnd);
  final Size nBegin;
  final Size nEnd;
  final Size pBegin;
  final Size pEnd;
}

/// A row of animated buttons with customizable properties.
///
/// The `AnimatedBtnRow` widget represents a row of buttons that
/// can appear or disappear based on the provided configuration.
/// It includes properties for button visibility, constraints, titles,
/// callbacks, colors, and loading states.
class AnimatedBtnRow extends StatefulWidget {
  /// Creates an `AnimatedBtnRow` widget.
  ///
  /// The [showrightBtn] and [showLeftBtn] properties control the visibility
  /// of the right and left buttons, respectively. The [constraints]
  /// specify the box constraints for the row.
  const AnimatedBtnRow({
    required this.showrightBtn,
    required this.showLeftBtn,
    required this.constraints,
    required this.rightBtnTitle,
    required this.leftBtnTitle,
    required this.onRightBtn,
    required this.onLeftBtn,
    required this.gap,
    this.rightBtnIsPrimary = true,
    this.leftBtnIsPrimary = true,
    this.rightBtnIsLoading = false,
    this.leftBtnIsLoading = false,
    super.key,
  });

  /// Whether the right button should be shown or hidden.
  final bool showrightBtn;

  /// Whether the left button should be shown or hidden.
  final bool showLeftBtn;

  /// The box constraints for the row.
  final BoxConstraints constraints;

  /// The actual button widget for the right widget.
  final Widget rightBtnTitle;

  /// The callback function to be invoked when the right button is pressed.
  final VoidCallback? onRightBtn;

  /// Whether the right button is in a loading state.
  final bool rightBtnIsLoading;

  /// Whether the right button is in a primary or secondary.
  final bool rightBtnIsPrimary;

  /// The actual button widget for the left widget.
  final Widget leftBtnTitle;

  /// The callback function to be invoked when the left button is pressed.
  final VoidCallback? onLeftBtn;

  /// Whether the left button is in a loading state.
  final bool leftBtnIsLoading;

  /// Whether the left button is in a primary or secondary.
  final bool leftBtnIsPrimary;

  /// The space between the right and left buttons.
  final double gap;

  @override
  State<AnimatedBtnRow> createState() => _AnimatedBtnRowState();
}

class _AnimatedBtnRowState extends State<AnimatedBtnRow>
    with TickerProviderStateMixin {
  late AnimationController nextBtnAnimationController;
  late Animation<Size> nextBtnSizeAnimation;

  late AnimationController prevBtnAnimationController;
  late Animation<Size> prevBtnSizeAnimation;

  late AnimationController gapAnimationController;

  late Size full;
  late Size half;
  late Size noWidth;
  late Size noWidthNoHeight;
  late Size noHeightFullWidth;
  late Size noHeightHalfWidth;

  @override
  void initState() {
    super.initState();

    final fullWidth = widget.constraints.maxWidth;
    full = Size(fullWidth, 50);
    half = Size(fullWidth / 2 - widget.gap / 2, 50);
    noWidth = const Size(0, 50);
    noWidthNoHeight = Size.zero;
    noHeightFullWidth = Size(fullWidth, 0);
    noHeightHalfWidth = Size(fullWidth / 2, 0);

    nextBtnAnimationController = makeAnimationController();
    prevBtnAnimationController = makeAnimationController();
    gapAnimationController = makeAnimationController();

    final sizes = getInitialSizes();

    nextBtnSizeAnimation =
        makeAnimation(nextBtnAnimationController, sizes.nBegin, sizes.nEnd);
    prevBtnSizeAnimation =
        makeAnimation(prevBtnAnimationController, sizes.pBegin, sizes.pEnd);
  }

  ({Size nBegin, Size nEnd, Size pBegin, Size pEnd}) getInitialSizes() {
    final nBegin = widget.showrightBtn ? full : Size.zero;
    const nEnd = Size.zero;
    final pBegin = widget.showLeftBtn ? full : Size.zero;
    const pEnd = Size.zero;

    return (nBegin: nBegin, nEnd: nEnd, pBegin: pBegin, pEnd: pEnd);
  }

  Animation<Size> makeAnimation(
    AnimationController controller,
    Size begin,
    Size end,
  ) {
    return controller.drive(
      Tween<Size>(
        begin: begin,
        end: end,
      ),
    );
  }

  AnimationController makeAnimationController() {
    return AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
  }

  @override
  void dispose() {
    nextBtnAnimationController.dispose();
    prevBtnAnimationController.dispose();
    super.dispose();
  }

  _Sizes getNewAnimationSizes(
    AnimatedBtnRow oldWidget,
    AnimatedBtnRow newWidget,
  ) {
    final oldShowNext = oldWidget.showrightBtn;
    final oldShowPrev = oldWidget.showLeftBtn;
    final newShowNext = newWidget.showrightBtn;
    final newShowPrev = newWidget.showLeftBtn;

    if (!oldShowNext && !newShowNext && !oldShowPrev && !newShowPrev) {
      return _Sizes(
        noWidthNoHeight,
        noWidthNoHeight,
        noWidthNoHeight,
        noWidthNoHeight,
      );
    } else if (!oldShowNext && !newShowNext && !oldShowPrev && newShowPrev) {
      return _Sizes(noWidthNoHeight, noWidthNoHeight, noHeightFullWidth, full);
    } else if (!oldShowNext && !newShowNext && oldShowPrev && !newShowPrev) {
      return _Sizes(noWidthNoHeight, noWidthNoHeight, full, noHeightFullWidth);
    } else if (!oldShowNext && !newShowNext && oldShowPrev && newShowPrev) {
      return _Sizes(noWidthNoHeight, noWidthNoHeight, full, full);
    } else if (!oldShowNext && newShowNext && !oldShowPrev && !newShowPrev) {
      return _Sizes(noHeightFullWidth, full, noWidthNoHeight, noWidthNoHeight);
    } else if (!oldShowNext && newShowNext && !oldShowPrev && newShowPrev) {
      return _Sizes(noHeightHalfWidth, half, noHeightHalfWidth, half);
    } else if (!oldShowNext && newShowNext && oldShowPrev && !newShowPrev) {
      return _Sizes(noWidth, full, full, noWidth);
    } else if (!oldShowNext && newShowNext && oldShowPrev && newShowPrev) {
      return _Sizes(noWidth, half, full, half);
    } else if (oldShowNext && !newShowNext && !oldShowPrev && !newShowPrev) {
      return _Sizes(full, noHeightFullWidth, noWidthNoHeight, noWidthNoHeight);
    } else if (oldShowNext && !newShowNext && !oldShowPrev && newShowPrev) {
      return _Sizes(full, noWidth, noWidth, full);
    } else if (oldShowNext && !newShowNext && oldShowPrev && !newShowPrev) {
      return _Sizes(half, noHeightHalfWidth, half, noHeightHalfWidth);
    } else if (oldShowNext && !newShowNext && oldShowPrev && newShowPrev) {
      return _Sizes(half, noWidth, half, full);
    } else if (oldShowNext && newShowNext && !oldShowPrev && !newShowPrev) {
      return _Sizes(full, full, noWidthNoHeight, noWidthNoHeight);
    } else if (oldShowNext && newShowNext && !oldShowPrev && newShowPrev) {
      return _Sizes(full, half, noWidth, half);
    } else if (oldShowNext && newShowNext && oldShowPrev && !newShowPrev) {
      return _Sizes(half, full, half, noWidth);
    } else {
      return _Sizes(half, half, half, half);
    }
  }

  @override
  void didUpdateWidget(covariant AnimatedBtnRow oldWidget) {
    super.didUpdateWidget(oldWidget);

    final sizes = getNewAnimationSizes(oldWidget, widget);

    nextBtnSizeAnimation = nextBtnAnimationController.drive(
      Tween<Size>(
        begin: sizes.nBegin,
        end: sizes.nEnd,
      ),
    );

    prevBtnSizeAnimation = prevBtnAnimationController.drive(
      Tween<Size>(
        begin: sizes.pBegin,
        end: sizes.pEnd,
      ),
    );

    animateBtn(nextBtnAnimationController);
    animateBtn(prevBtnAnimationController);

    if (widget.showrightBtn && widget.showLeftBtn) {
      gapAnimationController.forward();
    } else {
      gapAnimationController.reverse();
    }
  }

  void animateBtn(AnimationController controller) {
    controller
      ..reset()
      ..forward();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          AnimatedBuilder(
            animation: prevBtnSizeAnimation,
            builder: (context, child) {
              return ClipRRect(
                child: SizedBox(
                  height: prevBtnSizeAnimation.value.height,
                  width: prevBtnSizeAnimation.value.width,
                  child: widget.leftBtnIsPrimary
                      ? ActionButton.primary(
                          isLoading: widget.leftBtnIsLoading,
                          onPressed: widget.onLeftBtn,
                          child: widget.leftBtnTitle,
                        )
                      : ActionButton.secondary(
                          isLoading: widget.leftBtnIsLoading,
                          onPressed: widget.onLeftBtn,
                          child: widget.leftBtnTitle,
                        ),
                ),
              );
            },
          ),
          SizeTransition(
            axis: Axis.horizontal,
            sizeFactor: gapAnimationController,
            child: SizedBox(width: widget.gap),
          ),
          AnimatedBuilder(
            animation: nextBtnSizeAnimation,
            builder: (context, child) {
              return ClipRRect(
                child: SizedBox(
                  height: nextBtnSizeAnimation.value.height,
                  width: nextBtnSizeAnimation.value.width,
                  child: widget.rightBtnIsPrimary
                      ? ActionButton.primary(
                          isLoading: widget.rightBtnIsLoading,
                          onPressed: widget.onRightBtn,
                          child: widget.rightBtnTitle,
                        )
                      : ActionButton.secondary(
                          isLoading: widget.rightBtnIsLoading,
                          onPressed: widget.onRightBtn,
                          child: widget.rightBtnTitle,
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

/// A widget that animates the appearance of a button. The Animation transforms
/// the widgets size.
class AnimatedButtonShell extends StatefulWidget {
  /// Creates an AnimatedButtonShell widget.
  const AnimatedButtonShell({
    required this.button,
    required this.showBtn,
    required this.axisAlignment,
    super.key,
  });

  /// The button to be animated.
  final Widget button;

  /// Whether the button should be shown or hidden.
  final bool showBtn;

  /// The alignment of the button.
  final double axisAlignment;

  @override
  State<AnimatedButtonShell> createState() => _AnimatedButtonShellState();
}

class _AnimatedButtonShellState extends State<AnimatedButtonShell>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;
  @override
  void initState() {
    super.initState();
    animationController = makeAnimationController();
  }

  @override
  void dispose() {
    super.dispose();
    animationController.dispose();
  }

  @override
  void didUpdateWidget(covariant AnimatedButtonShell oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.showBtn != widget.showBtn) {
      if (widget.showBtn) {
        animationController.forward();
      } else {
        animationController.reverse();
      }
    }
  }

  AnimationController makeAnimationController() {
    return AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizeTransition(
      axisAlignment: widget.axisAlignment,
      sizeFactor: animationController,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          widget.button,
        ],
      ),
    );
  }
}
