import 'dart:async';

import 'package:carros/bloc/simple_bloc.dart';
import 'package:carros/model/carro.dart';
import 'package:carros/utils/db/carro_dao.dart';

class FavoritosBlock extends SimpleBloc<List<Carro>>{

  Future<List<Carro>> fetch() async {
    try {

      List<Carro> carros = await CarroDAO().findAllQuery("select * from carro c, favorito f where c.id = f.id");
      add(carros);
      return carros;
    } catch (error) {
      addError(error);
    }
  }
}