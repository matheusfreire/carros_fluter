import 'dart:async';

import 'package:provider/provider.dart';

class Event{

}

class EventBus{

  static EventBus get(context) => Provider.of<EventBus>(context, listen: false);

  final _streamContorller = StreamController<Event>.broadcast();

  Stream<Event> get stream => _streamContorller.stream;

  sendEvent(Event e){
    _streamContorller.add(e);
  }

  dispose(){
    _streamContorller.close();
  }
}