import 'dart:async';

/// A generic event stream for broadcasting events to multiple subscribers.
class EventStream<T> {
  final _controller = StreamController<T>.broadcast();

  final Map<void Function(T), StreamSubscription<T>> _subscriptions = {};

  /// Publishes an event to all subscribed handlers.
  void publish(T event) {
    _controller.add(event);
  }

  /// Subscribes a handler to receive events from the stream.
  void subscribe(void Function(T) handler) {
    _subscriptions[handler] = _controller.stream.listen(handler);
  }

  /// Unsubscribes a handler, stopping it from receiving further events.
  void unsubscribe(void Function(T) handler) {
    _subscriptions[handler]?.cancel();
  }

  /// Disposes of the event stream, canceling all subscriptions
  /// and closing the stream.
  void dispose() {
    _subscriptions.forEach((key, value) {
      value.cancel();
    });
    _controller.close();
  }
}
