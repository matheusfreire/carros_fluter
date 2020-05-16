import 'package:carros/bloc/carros_bloc.dart';
import 'package:carros/model/carro.dart';
import 'package:carros/pages/carro_page.dart';
import 'package:carros/utils/nav.dart';
import 'package:carros/utils/network.dart';
import 'package:flutter/material.dart';

class CarroListView extends StatefulWidget {
  TipoCarro tipo;

  CarroListView(this.tipo);

  @override
  _CarroListViewState createState() => _CarroListViewState();
}

class _CarroListViewState extends State<CarroListView> with AutomaticKeepAliveClientMixin<CarroListView> {
  List<Carro> carros;

  final _block = CarrosBlock();

  @override
  void initState() {
    super.initState();
    _block.fetch(widget.tipo);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return StreamBuilder(
      stream: _block.stream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasError) {
          print(snapshot.error);
          return Center(
            child: Text(
              "Não foi possível buscar os carros",
              style: TextStyle(
                color: Colors.red,
                fontSize: 22,
              ),
            ),
          );
        }
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        List<Carro> carros = snapshot.data;
        return _listView(carros);
      },
    );
  }

  _listView(List<Carro> carros) {
    return Container(
      padding: EdgeInsets.all(16),
      child: ListView.builder(
          itemCount: carros != null ? carros.length : 0,
          itemBuilder: (context, index) {
            Carro c = carros[index];
            return Card(
              elevation: 4,
              child: Container(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Center(
                      child: Image.network(
                        c.urlFoto ?? "https://storage.googleapis.com/carros-flutterweb.appspot.com/convite-animado-relampago-mcqueen-carros-2.jpg",
                        width: 250,
                      ),
                    ),
                    Text(
                      c.nome,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 25,
                      ),
                    ),
                    Text(
                      "descrição...",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 14,
                      ),
                    ),
                    ButtonBar(
                      children: <Widget>[
                        FlatButton(
                          child: const Text('DETALHES'),
                          onPressed: () => _onClickCarro(c),
                        ),
                        FlatButton(
                          child: const Text('SHARE'),
                          onPressed: () {
                            /* ... */
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }),
    );
  }

  @override
  bool get wantKeepAlive => true;

  _onClickCarro(Carro c) {
    push(context, CarroPage(c));
  }

  @override
  void dispose() {
    super.dispose();
    _block.dispose();
  }
}
