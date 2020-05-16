import 'package:carros/bloc/carros_model.dart';
import 'package:carros/model/carro.dart';
import 'package:carros/pages/carro_page.dart';
import 'package:carros/utils/nav.dart';
import 'package:carros/utils/network.dart';
import 'package:carros/widgets/text_error.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

class CarroListView extends StatefulWidget {
  TipoCarro tipo;

  CarroListView(this.tipo);

  @override
  _CarroListViewState createState() => _CarroListViewState();
}

class _CarroListViewState extends State<CarroListView>
    with AutomaticKeepAliveClientMixin<CarroListView> {
  List<Carro> carros;

  final _model = CarrosModel();

  @override
  void initState() {
    super.initState();
    _fetch();
  }

  _fetch() {
    _model.fetch(widget.tipo);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Observer(
      builder: (_) {
        List<Carro> carros = _model.carros;
        if (_model.error != null) {
          return TextError(
            "Não foi possível buscar os carros\n\nClique aqui para tentar novamente",
            onPressed: _fetch(),
          );
        }
        if (carros == null) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
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
                        c.urlFoto ??
                            "https://storage.googleapis.com/carros-flutterweb.appspot.com/convite-animado-relampago-mcqueen-carros-2.jpg",
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

}
