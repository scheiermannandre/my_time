import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_time/config/theme/tokens/space_tokens.dart';
import 'package:my_time/core/widgets/action_button.dart';

/// Shows a mighty styled Ok Alert Dialog.
Future<void> showOkAlertDialog(
  BuildContext context,
  String title,
  String content,
) async {
  return showDialog<void>(
    context: context,
    builder: (context) => OkAlertDialog(title: title, content: content),
  );
}

/// Shows a mighty styled Ok Alert Dialog.
Future<void> showOkAlertDialogCustomContent(
  BuildContext context,
  String title,
  Widget content,
) async {
  return showDialog<void>(
    context: context,
    builder: (context) =>
        OkAlertDialogCustomContent(title: title, content: content),
  );
}

/// A simple alert dialog widget with an 'Ok' button.
class OkAlertDialog extends ConsumerWidget {
  /// Constructs a [OkAlertDialog] with specified [title] and [content].
  const OkAlertDialog({
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
    return AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: [
        ActionButton.text(
          child: const Text('Ok'),
          onPressed: () async {
            Navigator.of(context).pop();
          },
        ),
      ],
      actionsAlignment: MainAxisAlignment.end,
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
class OkAlertDialogCustomContent extends ConsumerWidget {
  /// Constructs a [OkAlertDialogCustomContent] with specified
  /// [title] and [content].
  const OkAlertDialogCustomContent({
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
    return AlertDialog(
      title: Text(title),
      content: content,
      actions: [
        ActionButton.text(
          child: const Text('Ok'),
          onPressed: () async {
            Navigator.of(context).pop();
          },
        ),
      ],
      actionsAlignment: MainAxisAlignment.end,
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
