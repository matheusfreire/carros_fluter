import 'package:carros/bloc/carros_bloc.dart';
import 'package:carros/bloc/favoritos_bloc.dart';
import 'package:carros/model/carro.dart';
import 'package:carros/utils/api_interface.dart';
import 'package:carros/widgets/carro_listview.dart';
import 'package:flutter/material.dart';

class FavoritosPage extends StatefulWidget {

  @override
  _FavoritosPageState createState() => _FavoritosPageState();
}

class _FavoritosPageState extends State<FavoritosPage> with AutomaticKeepAliveClientMixin<FavoritosPage> {
  final _bloc = FavoritosBlock();

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _bloc.fetch();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return StreamBuilder(
      stream: _bloc.stream,
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
    return _bloc.fetch();
  }

  @override
  void dispose() {
    super.dispose();
    _bloc.dispose();
  }

}
