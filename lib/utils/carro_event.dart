import 'package:carros/utils/event_bus.dart';

class CarroEvent extends Event{
  String tipo;
  String acao;

  CarroEvent(this.acao,this.tipo);

  @override
  String toString() {
    return 'CarroEvent{tipo: $tipo, acao: $acao}';
  }
}