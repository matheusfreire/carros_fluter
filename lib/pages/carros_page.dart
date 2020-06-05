import 'dart:async';

import 'package:carros/bloc/carros_bloc.dart';
import 'package:carros/model/carro.dart';
import 'package:carros/utils/api_interface.dart';
import 'package:carros/utils/carro_event.dart';
import 'package:carros/utils/event_bus.dart';
import 'package:carros/widgets/carro_listview.dart';
import 'package:flutter/material.dart';

class CarrosPage extends StatefulWidget {
  final TipoCarro tipo;

  CarrosPage(this.tipo);

  @override
  _CarrosPageState createState() => _CarrosPageState();
}

class _CarrosPageState extends State<CarrosPage> with AutomaticKeepAliveClientMixin<CarrosPage> {

  final _bloc = CarrosBloc();

  @override
  bool get wantKeepAlive => true;

  StreamSubscription<Event> streamSubscription;

  @override
  void initState() {
    super.initState();
    _bloc.fetch(widget.tipo);

    final bus = EventBus.get(context);
    streamSubscription = bus.stream.listen((e) {
      print("Event $e");
      CarroEvent carroEvent = e;
      if(carroEvent.tipo == widget.tipo.toString().replaceAll("TipoCarro.", "")){
        _bloc.fetch(widget.tipo);
      }
    });

  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return StreamBuilder(
      stream: _bloc.blocList.stream,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text("Não foi possível buscar os carros");
        }

        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        List<Carro> carros = snapshot.data;
        return RefreshIndicator(
          onRefresh: _onRefresh,
          child: CarroListView(carros),
        );
      },
    );
  }

  Future<void> _onRefresh() {
    return _bloc.fetch(widget.tipo);
  }

  @override
  void dispose() {
    super.dispose();
    _bloc.blocList.dispose();
    streamSubscription.cancel();
  }

}
