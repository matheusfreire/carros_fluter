import 'package:carros/model/carro.dart';
import 'package:carros/model/favorito.dart';
import 'package:carros/utils/db/favorito_dao.dart';

class FavoritoBloc {

  static favoritar(Carro c){
    Favorito f = Favorito.fromCarro(c);
    final dao = FavoritoDao();
    dao.save(f);
  }
}