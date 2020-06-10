import 'package:cached_network_image/cached_network_image.dart';
import 'package:carros/bloc/carros_bloc.dart';
import 'package:carros/bloc/description_bloc.dart';
import 'package:carros/bloc/favorito_bloc.dart';
import 'package:carros/model/carro.dart';
import 'package:carros/pages/carro_form_page.dart';
import 'package:carros/utils/alert.dart';
import 'package:carros/utils/api_response.dart';
import 'package:carros/utils/carro_event.dart';
import 'package:carros/utils/event_bus.dart';
import 'package:carros/utils/nav.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class CarroPage extends StatefulWidget {
  final Carro carro;

  CarroPage(this.carro);

  @override
  _CarroPageState createState() => _CarroPageState();
}

class _CarroPageState extends State<CarroPage> {
  final _descriptionBloc = DescriptionBloc();
  final _carroBloc = CarrosBloc();

  Color color = Colors.grey;

  @override
  void initState() {
    super.initState();
    _fetchDescription();
    Provider.of<FavoritoBloc>(context, listen: false).isFavorito(getCarro()).then((fav) {
      setState(() {
        color = fav ? Colors.red : Colors.grey;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(getCarro().nome),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.place),
              onPressed: _onClickMapa,
            ),
            IconButton(
              icon: Icon(Icons.videocam),
              onPressed: _onClickVideo,
            ),
            PopupMenuButton<int>(
              onSelected: (value) => _onClickPopUpMenu(value),
              itemBuilder: (context) {
                return [
                  PopupMenuItem(
                    value: 1,
                    child: Text("Editar"),
                  ),
                  PopupMenuItem(
                    value: 2,
                    child: Text("Deletar"),
                  ),
                  PopupMenuItem(
                    value: 3,
                    child: Text("Compartilhar"),
                  ),
                ];
              },
            )
          ],
        ),
        body: _body());
  }

  _onClickPopUpMenu(int value) {
    switch (value) {
      case 1:
        push(
            context,
            CarroFormPage(
              carro: getCarro(),
            ));
        break;
      case 2:
        deletar();
        break;
      case 3:
        print("Compartilhar");
        break;
    }
  }

  _body() {
    return Container(
      padding: EdgeInsets.all(16),
      child: ListView(
        children: <Widget>[
          CachedNetworkImage(
            imageUrl: getCarro().urlFoto ?? "https://storage.googleapis.com/carros-flutterweb.appspot.com/convite-animado-relampago-mcqueen-carros-2.jpg",
          ),
          _blockOne(),
          Divider(),
          _blockTwo()
        ],
      ),
    );
  }

  _blockTwo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(
          height: 16,
        ),
        Text(
          getCarro().descricao,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        SizedBox(
          height: 16,
        ),
        StreamBuilder<String>(
          stream: _descriptionBloc.stream,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            return Text(
              snapshot.data,
              style: TextStyle(
                fontSize: 16,
              ),
            );
          },
        )
      ],
    );
  }

  _blockOne() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              getCarro().nome,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text(
              getCarro().tipo,
              style: TextStyle(
                fontSize: 16,
              ),
            )
          ],
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            IconButton(
              icon: Icon(
                Icons.favorite,
                color: color,
                size: 40,
              ),
              onPressed: _onClickFavorite,
            ),
            IconButton(
              icon: Icon(Icons.share, size: 40),
              onPressed: _onClickShare,
            )
          ],
        )
      ],
    );
  }

  _onClickMapa() {}

  _onClickVideo() {
    if(getCarro() != null &&  getCarro().urlVideo.isNotEmpty){
      launch(getCarro().urlVideo);
    } else {
      alert(context, "Erro","Este carro não possui nenhum vídeo");
    }
  }

  Carro getCarro() => widget.carro;

  _onClickShare() {}

  _onClickFavorite() async {
    bool favoritar = await Provider.of<FavoritoBloc>(context, listen: false).favoritar(getCarro());
    setState(() {
      color = favoritar ? Colors.red : Colors.grey;
    });
  }

  _fetchDescription() {
    _descriptionBloc.fetch();
  }

  void deletar() async {
    ApiResponse response = await _carroBloc.delete(getCarro());
    if (response.success) {
      alert(context,"Carros",  "Carro deletado com sucesso", callBack: () {
        EventBus.get(context).sendEvent(CarroEvent("carro_deletado", getCarro().tipo));
        Navigator.pop(context);
      });
    } else {
      alert(context,"Carros",response.msg);
    }
  }

  @override
  void dispose() {
    super.dispose();
    _descriptionBloc.dispose();
  }
}
