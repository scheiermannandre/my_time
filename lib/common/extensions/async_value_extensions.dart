import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_time/common/extensions/build_context_extension.dart';
import 'package:my_time/exceptions/custom_app_exception.dart';
import 'package:my_time/foundation/core/modals/modal_dialog_ui.dart';

/// Extension for the [AsyncValue] class.
extension AsyncValueUI<T> on AsyncValue<T> {
  /// Shows an [AlertDialog] with the error message.
  Future<bool?> showAlertDialogOnError(BuildContext context) async {
    if (!isRefreshing && hasError) {
      final message = _errorMessage(error, context);
      await ModalDialogUI.showOk(
        context: context,
        title: context.loc.errorPopUpHeader,
        content: message,
      );
      return null;
    }
    return null;
  }

  String _errorMessage(Object? error, BuildContext context) {
    if (error is CustomAppException) {
      return error.message(context.loc).message;
    } else {
      return error.toString();
    }
  }
}
