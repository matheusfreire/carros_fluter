import 'package:carros/bloc/simple_bloc.dart';
import 'package:carros/utils/api_interface.dart';

class DescriptionBloc extends SimpleBloc<String> {

  static String lorim;

  fetch() async {
    String s = lorim ?? await ApiInterface.getDescription();

    lorim = s;

    add(s);
  }
}