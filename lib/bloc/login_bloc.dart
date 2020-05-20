import 'dart:async';

import 'package:carros/model/usuario.dart';
import 'package:carros/utils/api_response.dart';
import 'package:carros/utils/api_interface.dart';

class LoginBlock{

  final _streamControllerProgress = StreamController<bool>();

  get stream => _streamControllerProgress.stream;

  Future<ApiResponse<Usuario>> login(String login, String senha) async {
    _streamControllerProgress.add(true);
    ApiResponse response = await ApiInterface.login(login, senha);

    _streamControllerProgress.add(false);
    return response;
  }

  void dispose(){
    _streamControllerProgress.close();
  }
}