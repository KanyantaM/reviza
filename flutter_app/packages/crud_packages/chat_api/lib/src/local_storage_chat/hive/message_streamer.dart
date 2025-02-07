import 'dart:async' as streamer;

class ListNotifier<T> {
  ListNotifier({required List<T> initialItems})
      : _items = List<T>.from(initialItems);

  final List<T> _items;
  final streamer.StreamController<List<T>> _controller =
      streamer.StreamController<List<T>>.broadcast();
  bool _isClosed = false; // Prevent emitting after disposal

  /// Expose the stream for listening
  Stream<List<T>> get stream => _controller.stream;

  /// Add item and emit only if it doesn't already exist
  void addItems(List<T> item) {
    if (!_isClosed && !_items.contains(item)) {
      _items.addAll(item);
      _emitUpdate();
    }
  }

  /// Remove item and emit only if it exists
  void removeItem(T item) {
    if (!_isClosed && _items.remove(item)) {
      _emitUpdate();
    }
  }

  /// Internal method to emit the updated list
  void _emitUpdate() {
    if (!_isClosed) {
      _controller.add(List<T>.from(_items)); // Emit a new list instance
    }
  }

  /// Dispose the stream when done
  void dispose() {
    if (!_isClosed) {
      _isClosed = true;
      _controller.close();
    }
  }
}
