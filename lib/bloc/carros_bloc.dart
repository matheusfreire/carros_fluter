import 'dart:async';

import 'package:carros/bloc/simple_bloc.dart';
import 'package:carros/model/carro.dart';
import 'package:carros/utils/api_interface.dart';
import 'package:carros/utils/db/carro_dao.dart';
import 'package:carros/utils/network.dart';

class CarrosBlock extends SimpleBloc<List<Carro>>{

  Future<List<Carro>> fetch(TipoCarro tipoCarro) async {
    try {

      String tipo = tipoCarro.toString().replaceAll("TipoCarro.", "");

      if(! await isNetworkOn()){
        List<Carro> carros = await CarroDAO().findAllByTipo(tipo);
        add(carros);
        return carros;
      }

      List<Carro> carros = await ApiInterface.getCarros(tipo);

      _saveCarIntoDB(carros);
      add(carros);
      return carros;
    } catch (error) {
      addError(error);
    }
  }

  void _saveCarIntoDB(List<Carro> carros) {
    if(carros.isNotEmpty){
      final dao = new CarroDAO();
      carros.forEach(dao.save);
    }
  }

}