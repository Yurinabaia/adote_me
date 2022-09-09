import 'dart:async';

class GenericBloc<T> //sIGNIFICAR RECEBER QUALQER OBJETO CLASSE GENERICA
{
  final StreamController _controller = StreamController<T>.broadcast();

  void dispose() {
    _controller.close(); //fechar o controller
  }

  void add(Object T) {
    _controller.add(T);
  }

  get stream => _controller.stream;
}
