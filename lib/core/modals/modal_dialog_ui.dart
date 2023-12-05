import 'package:flutter/material.dart';
import 'package:my_time/config/theme/tokens/space_tokens.dart';
import 'package:my_time/core/widgets/action_button.dart';

/// Exposes methods to show modal dialogs.
class ModalDialogUI {
  /// Shows a mighty styled Ok Alert Dialog.
  static Future<void> showOk({
    required BuildContext context,
    required String title,
    required String content,
  }) async {
    return showDialog<void>(
      context: context,
      builder: (context) => _ModalDialog._ok(
        title: title,
        content: content,
        context: context,
      ),
    );
  }

  /// Show an Ok Dialog with custom Content.
  static Future<void> showOkWithCustomContent(
    BuildContext context,
    String title,
    Widget content,
  ) async {
    return showDialog<void>(
      context: context,
      builder: (context) => _ModalDialog._okWithCustomContent(
        title: title,
        content: content,
        context: context,
      ),
    );
  }

  /// Show custom Dialog.
  static Future<T?> show<T>({
    required BuildContext context,
    required String title,
    required Widget content,
    required List<Widget> actions,
  }) async {
    return showDialog<T>(
      context: context,
      builder: (context) => _ModalDialog._custom(
        title: title,
        content: content,
        actions: actions,
      ),
    );
  }
}

class _ModalDialog extends StatelessWidget {
  const _ModalDialog({
    required this.title,
    required this.content,
    required this.actions,
  });

  factory _ModalDialog._ok({
    required String title,
    required String content,
    required BuildContext context,
  }) {
    return _ModalDialog(
      title: title,
      content: Text(content),
      actions: [
        ActionButton.text(
          child: const Text('Ok'),
          onPressed: () async {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }

  factory _ModalDialog._okWithCustomContent({
    required String title,
    required Widget content,
    required BuildContext context,
  }) {
    return _ModalDialog(
      title: title,
      content: content,
      actions: [
        ActionButton.text(
          child: const Text('Ok'),
          onPressed: () async {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }

  factory _ModalDialog._custom({
    required String title,
    required Widget content,
    required List<Widget> actions,
  }) {
    return _ModalDialog(
      title: title,
      content: content,
      actions: actions,
    );
  }

  final String title;
  final Widget content;
  final List<Widget> actions;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
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
      actionsAlignment: MainAxisAlignment.end,
      actionsOverflowButtonSpacing: SpaceTokens.small,
      actionsOverflowDirection: VerticalDirection.down,
      actionsOverflowAlignment: OverflowBarAlignment.center,
      title: Text(title),
      content: content,
      actions: actions,
    );
  }
}
