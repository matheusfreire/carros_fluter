

import 'package:carros/model/carro.dart';
import 'package:carros/utils/db/base_dao.dart';


// Data Access Object
class CarroDAO extends BaseDao<Carro>{
  @override
  String get tableName => "carro";

  @override
  Carro fromMap(Map<String, dynamic> map) {
    return Carro.fromMap(map);
  }

  Future<List<Carro>> findAllByTipo(String tipo) {
    return findAllQuery('select * from $tableName where tipo =? ',[tipo]);
  }
}