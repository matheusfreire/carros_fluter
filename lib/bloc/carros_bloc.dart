import 'dart:async';

import 'package:carros/bloc/simple_block.dart';
import 'package:carros/model/carro.dart';
import 'package:carros/utils/network.dart';

class CarrosBlock extends SimpleBlock<List<Carro>>{

  fetch(TipoCarro tipo) async {
    try {
      List<Carro> carros = await Network.getCarros(tipo);
      add(carros);
    } catch (error, exception) {
      addError(error);
    }
  }

}