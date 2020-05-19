import 'package:cached_network_image/cached_network_image.dart';
import 'package:carros/model/carro.dart';
import 'package:flutter/material.dart';

class CarroPage extends StatelessWidget {
  Carro carro;

  CarroPage(this.carro);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(carro.nome),
        ),
        body: _body());
  }

  _body() {
    return Container(
      padding: EdgeInsets.all(16),
      child: CachedNetworkImage(
        imageUrl: carro.urlFoto,
      ),
    );
  }
}
