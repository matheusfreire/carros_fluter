import 'dart:async';
import 'dart:io';

import 'package:carros/bloc/simple_bloc.dart';
import 'package:carros/model/carro.dart';
import 'package:carros/utils/api_interface.dart';
import 'package:carros/utils/api_response.dart';
import 'package:carros/utils/db/carro_dao.dart';
import 'package:carros/utils/network.dart';

class CarrosBloc{

  var blocList = SimpleBloc<List<Carro>>();
  var blocSingle = SimpleBloc<Carro>();

  Future<List<Carro>> fetch(TipoCarro tipoCarro) async {
    try {

      String tipo = tipoCarro.toString().replaceAll("TipoCarro.", "");

      if(! await isNetworkOn()){
        List<Carro> carros = await CarroDAO().findAllByTipo(tipo);
        blocList.add(carros);
        return carros;
      }

      List<Carro> carros = await ApiInterface.getCarros(tipo);

      _saveCarIntoDB(carros);
      blocList.add(carros);
      return carros;
    } catch (error) {
      blocList.addError(error);
    }
  }

  void _saveCarIntoDB(List<Carro> carros) {
    if(carros.isNotEmpty){
      final dao = new CarroDAO();
      carros.forEach(dao.save);
    }
  }

  Future<ApiResponse> save(Carro c, File image) async{
    if(image != null){
      ApiResponse responsePhoto = await ApiInterface.savePhoto(image);
      if(responsePhoto.success) {
        String urlFoto = responsePhoto.result;
        c.urlFoto = urlFoto;
      }
    }

    ApiResponse response = await ApiInterface.saveCarro(c);
    return response;
  }

  Future<ApiResponse> delete(Carro carro) {
    return ApiInterface.deleteCarro(carro);
  }

}