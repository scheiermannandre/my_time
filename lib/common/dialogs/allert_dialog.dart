import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// Generic function to show a platform-aware Material or Cupertino dialog
Future<bool?> showAlertDialog({
  required BuildContext context,
  required String title,
  String? content,
  String? cancelActionText,
  String defaultActionText = 'OK',
}) async {
  if (kIsWeb || !Platform.isIOS) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: content != null ? Text(content) : null,
        actions: <Widget>[
          if (cancelActionText != null)
            TextButton(
              child: Text(
                cancelActionText,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ),
              onPressed: () => Navigator.of(context).pop(false),
            ),
          TextButton(
            child: Text(
              defaultActionText,
              style: TextStyle(
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),
            onPressed: () => Navigator.of(context).pop(true),
          ),
        ],
      ),
    );
  }
  return showCupertinoDialog(
    context: context,
    builder: (context) => CupertinoAlertDialog(
      title: Text(title),
      content: content != null ? Text(content) : null,
      actions: <Widget>[
        if (cancelActionText != null)
          CupertinoDialogAction(
            child: Text(
              cancelActionText,
              style: TextStyle(
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),
            onPressed: () => Navigator.of(context).pop(false),
          ),
        CupertinoDialogAction(
          child: Text(
            defaultActionText,
            style: TextStyle(
              color: Theme.of(context).colorScheme.secondary,
            ),
          ),
          onPressed: () => Navigator.of(context).pop(true),
        ),
      ],
    ),
  );
}

/// Generic function to show a platform-aware Material or Cupertino error dialog
Future<bool?> showExceptionAlertDialog({
  required BuildContext context,
  required String title,
  required dynamic exception,
}) async =>
    showAlertDialog(
      context: context,
      title: title,
      content: exception.toString(),
    );
