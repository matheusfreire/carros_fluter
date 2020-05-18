import 'dart:convert';

import 'package:carros/model/carro.dart';
import 'package:carros/model/usuario.dart';
import 'package:carros/utils/api_response.dart';
import 'package:carros/utils/db/carro_dao.dart';
import 'package:http/http.dart' as http;

enum TipoCarro{
  classicos,
  esportivos,
  luxo
}

class Network{
  static get api => "https://carros-springboot.herokuapp.com/api";

  static Future<ApiResponse<Usuario>> login(String login, String senha) async {
    try{
      var url = '$api/v2/login';

      Map params = {"username": login, "password": senha};
      Map<String, String> headers = {
        "Content-Type":"application/json"
      };

      String s = json.encode(params);

      print(">> $s");

      var response = await http.post(url, body: s, headers: headers);
      print('Request url:  ${response.request.url}');
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      Map mapResponse = jsonDecode(response.body);
      if(response.statusCode == 200){
        final user = Usuario.fromJson(mapResponse);
        user.save();
        return ApiResponse.success(user);
      }
      return ApiResponse.error(mapResponse["error"]);
    } catch(error, exception){
      print("Erro no login $error > $exception");
      return ApiResponse.error("Não foi possível fazer o login");
    }
  }

  static Future<List<Carro>> getCarros(TipoCarro tipoCarro) async {
    try{
      Usuario user = await Usuario.get();
      String tipo = tipoCarro.toString().replaceAll("TipoCarro.", "");

      Map<String, String> headers = {
        "Content-Type":"application/json",
        "Authorization": "Bearer ${user.token}"
      };

      var url = '$api/v2/carros/tipo/$tipo';
      print('Request url:  $url');

      var response = await http.get(url, headers: headers);
      String json = response.body;

      List list = jsonDecode(json);

      final carros = list.map<Carro>((m) => Carro.fromMap(m)).toList();

      final dao = new CarroDAO();

      carros.forEach(dao.save);

      return carros;
    } catch(error, exception){
      print("$error >> $exception");
      throw error;
    }
  }
}