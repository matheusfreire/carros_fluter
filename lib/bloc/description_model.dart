import 'package:carros/utils/network.dart';
import 'package:mobx/mobx.dart';

part 'description_model.g.dart';

class DescriptionModel = DescriptionModelBase with _$DescriptionModel;

abstract class DescriptionModelBase with Store {

  @observable
  String result;

  @observable
  Exception exception;

  @action
  fetch() async {
    try {
      exception = null;
      result = await Network.getLoremipsum();
    } catch (e) {
      print(e);
      this.exception = e;
    }
  }

}