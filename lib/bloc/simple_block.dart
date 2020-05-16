import 'dart:async';

class SimpleBlock<T>{
  final _controller = StreamController<T>();

  get stream => _controller.stream;

  void add(T obj){
    _controller.add(obj);
  }

  void addError(Object error){
    if(!_controller.isClosed){
      _controller.addError(error);
    }
  }

  void dispose(){
    _controller.close();
  }
}