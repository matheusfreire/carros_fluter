import 'package:carros/model/carro.dart';
import 'package:carros/utils/network.dart';
import 'package:mobx/mobx.dart';

part 'carros_model.g.dart';

class CarrosModel = CarrosModelBase with _$CarrosModel;

abstract class CarrosModelBase with Store {

  @observable
  List<Carro> carros;

  @observable
  Exception error;

  @action
  fetch(TipoCarro tipo) async {
      try {
        error = null;
        carros = await Network.getCarros(tipo);
      } catch (e) {
        this.error = e;
      }
  }

}