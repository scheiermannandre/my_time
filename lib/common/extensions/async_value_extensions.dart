import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_time/common/dialogs/allert_dialog.dart';

extension AsyncValueUI on AsyncValue {
  Future<bool?> showAlertDialogOnError(BuildContext context) async {
    if (!isLoading && hasError) {
      return await showExceptionAlertDialog(
        context: context,
        title: 'Error',
        exception: error,
      );
    }

    return null;
  }
}
