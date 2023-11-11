import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_time/config/theme/color_tokens.dart';
import 'package:my_time/config/theme/mighty_theme.dart';
import 'package:my_time/config/theme/space_tokens.dart';
import 'package:my_time/config/theme/text_style_tokens.dart';
import 'package:my_time/core/util/extentions/widget_ref_extension.dart';
import 'package:my_time/core/widgets/mighty_action_button.dart';
import 'package:my_time/core/widgets/wizard/wizard/wizard.dart';
import 'package:my_time/core/widgets/wizard/wizard/wizard_buttons.dart';
import 'package:my_time/core/widgets/wizard/wizard/wizard_step_indicator.dart';

/// A customizable wizard widget that guides the user through a series of steps.

class MightyWizard extends ConsumerWidget {
  /// Creates a MightyWizard widget.
  ///
  /// The [steps] parameter is a list of widgets representing the steps
  /// in the wizard.
  /// The [reviewStep] parameter is the widget to be displayed on the
  /// review step.
  /// The [skipBtnTitle], [nextBtnTitle], [previousBtnTitle],
  /// [lastPageBtnTitle], and [finishBtnTitle] parameters are titles for
  /// different buttons in the wizard.

  const MightyWizard({
    required this.steps,
    required this.reviewStep,
    required this.skipBtnTitle,
    required this.nextBtnTitle,
    required this.previousBtnTitle,
    required this.lastPageBtnTitle,
    required this.finishBtnTitle,
    super.key,
  });

  /// A list of widgets representing the steps in the wizard.
  final List<Widget> steps;

  /// The widget to be displayed on the review step.
  final Widget reviewStep;

  /// The title for the skip button.
  final String skipBtnTitle;

  /// The title for the next button.
  final String nextBtnTitle;

  /// The title for the previous button.
  final String previousBtnTitle;

  /// The title for the last page button.
  final String lastPageBtnTitle;

  /// The title for the finish button.
  final String finishBtnTitle;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mightyTheme = ref.watchStateProvider(
      context,
      mightyThemeControllerProvider,
      mightyThemeControllerProvider.notifier,
    );

    final themeController = mightyTheme.controller;

    final primaryBackgroundColor =
        themeController.themeMode == SystemThemeMode.light
            ? LightThemeColorTokens.primaryColor
            : DarkThemeColorTokens.primaryColor;

    final secondaryBackgroundColor =
        themeController.themeMode == SystemThemeMode.light
            ? LightThemeColorTokens.white
            : DarkThemeColorTokens.darkestColor;

    final primaryTextColor = themeController.themeMode == SystemThemeMode.light
        ? LightThemeColorTokens.black
        : DarkThemeColorTokens.black;

    final secondaryTextColor =
        themeController.themeMode == SystemThemeMode.light
            ? LightThemeColorTokens.black
            : DarkThemeColorTokens.lightestColor;

    final primaryBorderColor =
        themeController.themeMode == SystemThemeMode.light
            ? LightThemeColorTokens.black
            : null;
    final secondaryBorderColor =
        themeController.themeMode == SystemThemeMode.light
            ? LightThemeColorTokens.black
            : DarkThemeColorTokens.primaryColor;

    final primarySplashColor =
        themeController.themeMode == SystemThemeMode.light
            ? LightThemeColorTokens.darkColor
            : DarkThemeColorTokens.darkColor;

    final secondarySplashColor =
        themeController.themeMode == SystemThemeMode.light
            ? LightThemeColorTokens.mediumColor
            : DarkThemeColorTokens.lightestColor;

    final stepActiveColor = themeController.themeMode == SystemThemeMode.light
        ? LightThemeColorTokens.primaryColor
        : DarkThemeColorTokens.primaryColor;

    final stepInactiveColor = themeController.themeMode == SystemThemeMode.light
        ? LightThemeColorTokens.mediumColor
        : DarkThemeColorTokens.lightestColor;

    final appbarIconColor = themeController.themeMode == SystemThemeMode.light
        ? LightThemeColorTokens.darkestColor
        : DarkThemeColorTokens.darkestColor;

    return Wizard(
      infoIconColor: secondaryBorderColor,
      onFinish: () {},
      previousBtnTitle: Button(
        title: previousBtnTitle,
        titleColor: secondaryTextColor,
        type: BtnType.previous,
      ),
      nextBtnTitlePrimary: Button(
        title: nextBtnTitle,
        titleColor: primaryTextColor,
        type: BtnType.forward,
      ),
      nextBtnTitleSecondary: Button(
        title: nextBtnTitle,
        titleColor: secondaryTextColor,
        type: BtnType.forward,
      ),
      skipBtnTitle: Button(
        title: skipBtnTitle,
        titleColor: secondaryTextColor,
      ),
      lastPageBtnTitle: Button(
        title: lastPageBtnTitle,
        titleColor: primaryTextColor,
      ),
      finishBtnTitle: Button(
        title: finishBtnTitle,
        titleColor: primaryTextColor,
      ),
      backgroundColor: secondaryBackgroundColor,
      appBarTitleStyle: TextStyle(
        color: primaryTextColor,
      ),
      titleStyle: themeController.headline4,
      appBarBackgroundColor: primaryBackgroundColor,
      appBarIconColor: appbarIconColor,
      reviewStep: reviewStep,
      steps: steps,
      stepStyle: StepIndicatorStyle(
        activeColor: stepActiveColor,
        inactiveColor: stepInactiveColor,
      ),
      primary: WizardButtonStyle(
        backgroundColor: primaryBackgroundColor,
        splashColor: primarySplashColor,
        borderColor: primaryBorderColor,
      ),
      secondary: WizardButtonStyle(
        backgroundColor: secondaryBackgroundColor,
        splashColor: secondarySplashColor,
        borderColor: secondaryBorderColor,
      ),
      infoDialogBuilder: (context, title, description) => Consumer(
        builder: (context, ref, child) {
          final theme = ref.watchStateProvider(
            context,
            mightyThemeControllerProvider,
            mightyThemeControllerProvider.notifier,
          );
          return AlertDialog(
            backgroundColor: theme.controller.mainBackgroundColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                SpaceTokens.mediumSmall,
              ),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: SpaceTokens.medium,
            ),
            titlePadding: const EdgeInsets.all(
              SpaceTokens.medium,
            ),
            actionsPadding: const EdgeInsets.all(SpaceTokens.medium),
            actionsAlignment: MainAxisAlignment.center,
            actionsOverflowButtonSpacing: SpaceTokens.small,
            title: Text(title, style: theme.controller.headline5),
            content: Text(description, style: theme.controller.body),
            actions: [
              MightyActionButton.primary(
                themeController: theme.controller,
                label: 'Ok',
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          );
        },
      ),
    );
  }
}

/// Enum representing the type of a wizard button.
enum BtnType {
  /// [forward] is used for the next button because it adds an arrow pointing
  /// to the right.
  forward,

  /// [previous] is used for the previous button because it adds an arrow
  /// pointing to the left.
  previous,

  /// [regular] is used for all other buttons.
  regular,
}

/// A customizable button widget used in the MightyWizard widget.

class Button extends StatelessWidget {
  /// Creates a Button widget.
  ///
  /// The [titleColor] parameter is the color of the button title.
  /// The [title] parameter is the title text of the button.
  /// The [type] parameter is the type of the button
  /// (forward, previous, regular).

  const Button({
    required this.titleColor,
    required this.title,
    this.type = BtnType.regular,
    super.key,
  });

  /// The color of the button title.
  final Color titleColor;

  /// The type of the button (forward, previous, regular).
  final BtnType type;

  /// The title text of the button.
  final String title;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: SpaceTokens.medium),
      child: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Opacity(
              opacity: type == BtnType.previous ? 1 : 0,
              child: Icon(
                Icons.arrow_back_ios_rounded,
                color: titleColor,
              ),
            ),
            Text(
              title,
              style: TextStyleTokens.body(titleColor),
              overflow: TextOverflow.fade,
            ),
            Opacity(
              opacity: type == BtnType.forward ? 1 : 0,
              child: Icon(
                Icons.arrow_forward_ios_rounded,
                color: titleColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
