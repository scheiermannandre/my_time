import 'package:flutter/widgets.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:my_time/common/extensions/async_value_extensions.dart';

/// A typedef representing a record that includes a controller and a state.
typedef WidgetRefRecord<Controller, State> = ({
  Controller controller,
  State state
});

/// Extension methods for the `WidgetRef` class providing additional
/// functionality.
extension WidgetRefExtension on WidgetRef {
  /// Watches and listens to changes in an asynchronous value provider,
  /// displaying an alert dialog on error.
  ///
  /// Returns the watched asynchronous value.
  AsyncValue<T> watchAndListenAsyncValueErrors<T>(
    BuildContext context,
    ProviderListenable<AsyncValue<T>> provider,
  ) {
    listen(
      provider,
      (previous, next) => next.showAlertDialogOnError(context),
    );
    return watch<AsyncValue<T>>(provider);
  }

  /// Watches a state provider and a refreshable notifier, returning a record
  /// that includes the controller and the watched state.
  WidgetRefRecord<Controller, State> watchStateProvider<Controller, State>(
    BuildContext context,
    ProviderListenable<State> provider,
    Refreshable<Controller> notifier,
  ) =>
      (controller: read(notifier), state: watch<State>(provider));

  /// Watches and listens to changes in a state provider, displaying an alert
  /// dialog on error. Returns a record that includes the controller and the
  /// watched state.
  WidgetRefRecord<Controller, State>
      watchAndListenStateProviderError<Controller, State>(
    BuildContext context,
    ProviderListenable<State> provider,
    Refreshable<Controller> notifier,
  ) {
    listen(provider, (previous, next) {
      if (next is! AsyncValue) return;
      next.showAlertDialogOnError(context);
    });
    return (
      controller: read(notifier),
      state: watch<State>(provider),
    );
  }
}
