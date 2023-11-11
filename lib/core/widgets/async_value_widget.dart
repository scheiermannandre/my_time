import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// A widget that reacts to the different states of an asynchronous value.
///
/// It takes a [value] of type [AsyncValue<T>] and defines three
/// callback functions:
/// - [data]: Called when the [value] is of type [AsyncData<T>], and it's not
/// in a refreshing state.
/// - [error]: Called when the [value] is of type [AsyncError], and it's not
/// in a refreshing state.
/// - [loading]: Called when the [value] is in a refreshing state.
///
/// This widget uses the when method of [AsyncValue] to determine the
/// current state
/// and invoke the appropriate callback function.
class AsyncValueWidget<T> extends StatelessWidget {
  /// Constructs an [AsyncValueWidget] with required parameters.
  const AsyncValueWidget({
    required this.value,
    required this.data,
    required this.loading,
    required this.error,
    super.key,
  });

  /// The asynchronous value to react to.
  final AsyncValue<T> value;

  /// Callback function to be invoked when the value is of type [AsyncData<T>],
  /// and it's not in a refreshing state.
  final Widget Function(T) data;

  /// Callback function to be invoked when the value is in a refreshing state.
  final Widget Function() loading;

  /// Callback function to be invoked when the value is of type [AsyncError],
  /// and it's not in a refreshing state.
  final Widget Function(Object, StackTrace) error;

  @override
  Widget build(BuildContext context) {
    return value.when(
      data: (dataValue) => !value.isRefreshing ? data(dataValue) : loading(),
      error: (e, st) => !value.isRefreshing ? error(e, st) : loading(),
      loading: loading,
    );
  }
}

/// A sliver equivalent of [AsyncValueWidget].
///
/// It reacts to the different states of an asynchronous value and returns
/// a corresponding sliver widget.
class AsyncValueSliverWidget<T> extends StatelessWidget {
  /// Constructs an [AsyncValueSliverWidget] with required parameters.
  const AsyncValueSliverWidget({
    required this.value,
    required this.data,
    required this.error,
    required this.loading,
    super.key,
  });

  /// The asynchronous value to react to.
  final AsyncValue<T> value;

  /// Callback function to be invoked when the value is of type [AsyncData<T>].
  final Widget Function(T) data;

  /// Callback function to be invoked when the value is in a refreshing state.
  final Widget Function() loading;

  /// Callback function to be invoked when the value is of type [AsyncError].
  final Widget Function(Object, StackTrace) error;

  @override
  Widget build(BuildContext context) {
    return value.when(
      data: data,
      loading: () => SliverToBoxAdapter(
        child: loading(),
      ),
      error: (e, st) => SliverToBoxAdapter(
        child: error(e, st),
      ),
    );
  }
}
