import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_time/config/theme/mighty_theme.dart';
import 'package:my_time/config/theme/tokens/space_tokens.dart';
import 'package:my_time/core/util/extentions/widget_ref_extension.dart';
import 'package:my_time/core/widgets/mighty_action_button.dart';

/// Shows a mighty styled Ok Alert Dialog.
Future<void> showMightyOkAlertDialog(
  BuildContext context,
  String title,
  String content,
) async {
  return showDialog<void>(
    context: context,
    builder: (context) => MightyOkAlertDialog(title: title, content: content),
  );
}

/// Shows a mighty styled Ok Alert Dialog.
Future<void> showMightyOkAlertDialogCustomContent(
  BuildContext context,
  String title,
  Widget content,
) async {
  return showDialog<void>(
    context: context,
    builder: (context) =>
        MightyOkAlertDialogCustomContent(title: title, content: content),
  );
}

/// A simple alert dialog widget with an 'Ok' button.
class MightyOkAlertDialog extends ConsumerWidget {
  /// Constructs a [MightyOkAlertDialog] with specified [title] and [content].
  const MightyOkAlertDialog({
    required this.content,
    required this.title,
    super.key,
  });

  /// The title of the alert dialog.
  final String title;

  /// The content text of the alert dialog.
  final String content;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.watchStateProvider(
      context,
      mightyThemeControllerProvider,
      mightyThemeControllerProvider.notifier,
    );

    return AlertDialog(
      title: Text(title, style: theme.controller.headline4),
      content: Text(content, style: theme.controller.body),
      actions: [
        MightyActionButton.flatText(
          themeController: theme.controller,
          onPressed: () {
            Navigator.of(context).pop();
          },
          label: 'Ok',
        ),
      ],
      actionsAlignment: MainAxisAlignment.end,
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
      actionsOverflowButtonSpacing: SpaceTokens.small,
    );
  }
}

/// A simple alert dialog widget with an 'Ok' button.
class MightyOkAlertDialogCustomContent extends ConsumerWidget {
  /// Constructs a [MightyOkAlertDialogCustomContent] with specified
  /// [title] and [content].
  const MightyOkAlertDialogCustomContent({
    required this.content,
    required this.title,
    super.key,
  });

  /// The title of the alert dialog.
  final String title;

  /// The content text of the alert dialog.
  final Widget content;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.watchStateProvider(
      context,
      mightyThemeControllerProvider,
      mightyThemeControllerProvider.notifier,
    );

    return AlertDialog(
      title: Text(title, style: theme.controller.headline4),
      content: content,
      actions: [
        MightyActionButton.flatText(
          themeController: theme.controller,
          onPressed: () {
            Navigator.of(context).pop();
          },
          label: 'Ok',
        ),
      ],
      actionsAlignment: MainAxisAlignment.end,
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
      actionsOverflowButtonSpacing: SpaceTokens.small,
    );
  }
}
