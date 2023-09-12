import 'package:flutter/foundation.dart';

void _ignoreOverflowErrors(
  FlutterErrorDetails details, {
  bool forceReport = true,
}) {
  var ifIsOverflowError = false;
  var isUnableToLoadAsset = false;

  // Detect overflow error.
  final exception = details.exception;
  if (exception is FlutterError) {
    ifIsOverflowError = !exception.diagnostics.any(
      (e) => e.value.toString().startsWith('A RenderFlex overflowed by'),
    );
    isUnableToLoadAsset = !exception.diagnostics.any(
      (e) => e.value.toString().startsWith('Unable to load asset'),
    );
  }

  // Ignore if is overflow error.
  if (ifIsOverflowError || isUnableToLoadAsset) {
    debugPrint('Ignored Error');
  } else {
    FlutterError.dumpErrorToConsole(details, forceReport: forceReport);
  }
}

Future<void> disableOverflowErrorsFor(
  Future<void> Function() executeWithoutOverflow,
) async {
  final originalFlutterError = FlutterError.onError;
  FlutterError.onError = _ignoreOverflowErrors;
  await executeWithoutOverflow();
  FlutterError.onError = originalFlutterError;
}
