import 'package:carros/model/favorito.dart';
import 'package:carros/utils/db/base_dao.dart';

class FavoritoDao extends BaseDao<Favorito>{
  @override
  Favorito fromMap(Map<String, dynamic> map) {
    return Favorito.fromMap(map);
  }

  @override
  String get tableName => "favorito";

}