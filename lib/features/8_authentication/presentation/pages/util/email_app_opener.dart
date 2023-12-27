import 'package:flutter/material.dart';
import 'package:my_time/common/common.dart';
import 'package:my_time/foundation/core/modals/modal_bottom_sheet_ui.dart';
import 'package:my_time/foundation/core/modals/modal_dialog_ui.dart';
import 'package:my_time/foundation/core/widgets/labeled_list_tiles.dart';
import 'package:open_mail_app/open_mail_app.dart';

/// A utility class to fetch and work with email apps available on the device.
class EmailApps {
  /// Retrieves a list of available email apps on the device asynchronously.
  static Future<List<EmailApp>> get() async {
    final result = await OpenMailApp.getMailApps();
    return result.map((e) => EmailApp(app: e)).toList();
  }
}

/// Represents an email app.
class EmailApp {
  /// Constructs an [EmailApp] with the provided [app].
  EmailApp({required MailApp app}) : _app = app;

  final MailApp _app;

  /// Retrieves the name of the email app.
  String get name => _app.name;

  /// Opens the specific email app.
  Future<void> open() async {
    await OpenMailApp.openSpecificMailApp(_app);
  }
}

/// A user interface handler for working with email apps.
class EmailAppsUI extends EmailApps {
  /// Shows the email apps available and handles their interaction.
  ///
  /// Parameters:
  /// - `context`: The build context for the UI.
  /// - `themeController`: The controller for managing the theme.
  /// - `animationController`: The controller for managing animations.
  static Future<void> show({
    required BuildContext context,
    required AnimationController animationController,
  }) async {
    final emailApps = await EmailApps.get();

    if (!context.mounted) return;

    if (emailApps.isEmpty) {
      await ModalDialogUI.showOk(
        context: context,
        title: context.loc.emailOpenerNoAppsTitle,
        content: context.loc.emailOpenerNoAppsDescription,
      );

      return;
    }

    if (emailApps.length == 1) {
      await emailApps.first.open();
      return;
    }

    final clickedIndex = await ModalBottomSheetUI.showPage<int>(
      heightFactor: .5,
      context: context,
      bottomSheetController: animationController,
      widget: LabeledListTiles(
        showIcons: false,
        label: context.loc.emailOpenerPickAppTitle,
        items: emailApps.map((emailApp) => emailApp.name).toList(),
      ),
    );

    if (clickedIndex != null) {
      await emailApps[clickedIndex].open();
    }
  }
}
