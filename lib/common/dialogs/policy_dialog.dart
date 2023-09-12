import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:my_time/common/extensions/build_context_extension.dart';

/// Shows a dialog with a markdown file.
class PolicyDialog extends StatelessWidget {
  /// Constructor for the [PolicyDialog].
  PolicyDialog({
    required String mdFileName,
    super.key,
    double radius = 5,
  })  : _mdFileName = mdFileName,
        _borderRadius = radius,
        assert(
          mdFileName.contains('.md'),
          'The file must contain the .md extension',
        );

  /// Key to find the close button in a test.
  static const closePolicyDialogBtnKey = Key('closePolicyDialogKey');

  final double _borderRadius;
  final String _mdFileName;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.all(25),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(_borderRadius),
      ),
      child: Column(
        children: [
          Expanded(
            child: FutureBuilder(
              future: Future<void>.delayed(const Duration(milliseconds: 150))
                  .then((value) {
                return rootBundle.loadString('assets/$_mdFileName');
              }),
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
          const Padding(
            padding: EdgeInsets.only(bottom: 5),
          ),
          ElevatedButton(
            key: closePolicyDialogBtnKey,
            onPressed: () => Navigator.of(context).pop(),
            style: ButtonStyle(
              shape: MaterialStateProperty.all(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(_borderRadius),
                    bottomRight: Radius.circular(_borderRadius),
                  ),
                ),
              ),
            ),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(_borderRadius),
                  bottomRight: Radius.circular(_borderRadius),
                ),
              ),
              alignment: Alignment.center,
              height: 22.5,
              width: double.infinity,
              child: Text(
                context.loc.closePolicyDialog,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
