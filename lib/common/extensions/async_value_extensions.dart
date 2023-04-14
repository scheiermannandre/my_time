import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_time/common/dialogs/allert_dialog.dart';
import 'package:my_time/common/extensions/build_context_extension.dart';
import 'package:my_time/exceptions/app_exception.dart';

extension AsyncValueUI on AsyncValue {
  Future<bool?> showAlertDialogOnError(BuildContext context) async {
    if (!isRefreshing && hasError) {
      final message = _errorMessage(error, context);
      return await showExceptionAlertDialog(
        context: context,
        title: context.loc.errorPopUpHeader,
        exception: message,
      );
    }

    return null;
  }

  String _errorMessage(Object? error, BuildContext context) {
    if (error is AppException) {
      return error.message(context.loc).message;
    } else {
      return error.toString();
    }
  }
}
