import 'package:carros/bloc/favorito_bloc.dart';
import 'package:carros/model/carro.dart';
import 'package:carros/widgets/carro_listview.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FavoritosPage extends StatefulWidget {

  @override
  _FavoritosPageState createState() => _FavoritosPageState();
}

class _FavoritosPageState extends State<FavoritosPage> with AutomaticKeepAliveClientMixin<FavoritosPage> {
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    FavoritoBloc bloc = Provider.of<FavoritoBloc>(context, listen: false);
    bloc.fetch();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return StreamBuilder(
      stream: Provider.of<FavoritoBloc>(context).stream,
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
    return Provider.of<FavoritoBloc>(context, listen: false).fetch();
  }

}
