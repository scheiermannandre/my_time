import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_time/common/extensions/build_context_extension.dart';
import 'package:my_time/foundation/config/theme/tokens/color_tokens.dart';
import 'package:my_time/foundation/config/theme/tokens/corner_radius_tokens.dart';
import 'package:my_time/foundation/config/theme/tokens/space_tokens.dart';
import 'package:my_time/foundation/config/theme/tokens/text_style_tokens.dart';
import 'package:my_time/foundation/core/widgets/action_button.dart';

/// Utility class to display a dialog with a markdown file content.
class MightyMarkDownDialog {
  /// Displays a dialog with the content of a markdown file.
  ///
  /// [context] The [BuildContext] to show the dialog.
  /// [mdFileName] The name of the markdown file to display.
  static Future<void> show({
    required BuildContext context,
    required String mdFileName,
  }) async {
    assert(
      mdFileName.contains('.md'),
      'The file must contain the .md extension',
    );
    await showDialog<void>(
      context: context,
      builder: (context) => MarkDownDialog(
        mdFileName: mdFileName,
      ),
    );
  }
}

/// Dialog widget to display markdown content.
class MarkDownDialog extends ConsumerWidget {
  /// Constructs a [MarkDownDialog].
  const MarkDownDialog({
    required this.mdFileName,
    super.key,
    this.borderRadius = CornerRadiusTokens.small,
  });

  /// The name of the markdown file to display.
  final String mdFileName;

  /// The border radius of the dialog.
  final double borderRadius;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Dialog(
      insetPadding: const EdgeInsets.all(25),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: Column(
        children: [
          Expanded(
            child: FutureBuilder(
              future: rootBundle.loadString('assets/$mdFileName'),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Markdown(
                    data: snapshot.data!,
                  );
                }
                return const Center(
                  child: CircularProgressIndicator(),
                );
              },
            ),
          ),
          // Close button
          Padding(
            padding: const EdgeInsets.all(SpaceTokens.small),
            child: ActionButton.text(
              child: Text(
                context.loc.closePolicyDialog,
                style: TextStyleTokens.body(LightThemeColorTokens.black),
                textAlign: TextAlign.center,
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
        ],
      ),
    );
  }
}
