import 'dart:async';

class GenericBloc<T> {
  final StreamController _controller = StreamController<T>.broadcast();

  void dispose() {
    _controller.close();
  }

  void add(Object T) {
    _controller.add(T);
  }

  get stream => _controller.stream;
}
