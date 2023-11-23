import 'dart:async';

import 'package:flutter/foundation.dart';

/// A notifier that listens to a provided stream and notifies
/// its listeners when the stream emits a new event.
class GoRouterRefreshStream extends ChangeNotifier {
  /// Constructs a [GoRouterRefreshStream] with the provided [stream].
  ///
  /// The notifier notifies its listeners whenever the
  /// [stream] emits a new event.
  GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen(
      (dynamic _) {
        notifyListeners();
      },
    );
  }

  late final StreamSubscription<dynamic> _subscription;

  /// Disposes the subscription when the notifier is no longer needed.
  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
