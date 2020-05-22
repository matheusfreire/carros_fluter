import 'package:cached_network_image/cached_network_image.dart';
import 'package:carros/bloc/description_bloc.dart';
import 'package:carros/bloc/favorito_bloc.dart';
import 'package:carros/model/carro.dart';
import 'package:flutter/material.dart';

class CarroPage extends StatefulWidget {
  final Carro carro;

  CarroPage(this.carro);

  @override
  _CarroPageState createState() => _CarroPageState();
}

class _CarroPageState extends State<CarroPage> {
  final _descriptionBloc = DescriptionBloc();

  Color color = Colors.grey;

  @override
  void initState() {
    super.initState();
    _fetchDescription();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.carro.nome),
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
        print("Editar");
        break;
      case 2:
        print("Deletar");
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
            imageUrl: widget.carro.urlFoto,
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
          widget.carro.descricao,
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
              widget.carro.nome,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text(
              widget.carro.tipo,
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

  _onClickVideo() {}

  _onClickShare() {}

  _onClickFavorite() async {
    bool favoritar = await FavoritoBloc().favoritar(widget.carro);
    setState(() {
      // ignore: unnecessary_statements
      print(favoritar);
      color = favoritar ? Colors.red : Colors.grey;
    });
  }

  _fetchDescription() {
    _descriptionBloc.fetch();
  }
}
