import 'package:carros/bloc/simple_bloc.dart';
import 'package:carros/model/carro.dart';
import 'package:carros/model/favorito.dart';
import 'package:carros/utils/db/carro_dao.dart';
import 'package:carros/utils/db/favorito_dao.dart';

class FavoritoBloc extends SimpleBloc<List<Carro>> {

  Future<bool> favoritar(Carro c) async {
    Favorito f = Favorito.fromCarro(c);
    final dao = FavoritoDao();
    if(await dao.exists(c.id)){
      dao.delete(c.id);
      return false;
    } else {
      dao.save(f);
      return true;
    }
  }

  Future<List<Carro>> fetch() async {
    try {
      List<Carro> carros = await CarroDAO().findAllQuery("select * from carro c, favorito f where c.id = f.id");
      add(carros);
      return carros;
    } catch (error) {
      addError(error);
    }
  }

  Future<bool> isFavorito(Carro c) async {
    final dao = FavoritoDao();
    return dao.exists(c.id);
  }

}