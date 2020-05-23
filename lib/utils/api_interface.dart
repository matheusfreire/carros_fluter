import 'dart:convert';

import 'package:carros/model/carro.dart';
import 'package:carros/model/usuario.dart';
import 'package:carros/utils/api_response.dart';
import 'package:http/http.dart' as http;

enum TipoCarro { classicos, esportivos, luxo }

class ApiInterface {
  static get api => "https://carros-springboot.herokuapp.com/api";

  static Future<ApiResponse<Usuario>> login(String login, String senha) async {
    try {
      var url = '$api/v2/login';

      Map params = {"username": login, "password": senha};
      Map<String, String> headers = {"Content-Type": "application/json"};

      String s = json.encode(params);

      print(">> $s");

      var response = await http.post(url, body: s, headers: headers);
      print('Request url:  ${response.request.url}');
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      Map mapResponse = jsonDecode(response.body);
      if (response.statusCode == 200) {
        final user = Usuario.fromJson(mapResponse);
        user.save();
        return ApiResponse.success(user);
      }
      return ApiResponse.error(mapResponse["error"]);
    } catch (error, exception) {
      print("Erro no login $error > $exception");
      return ApiResponse.error("Não foi possível fazer o login");
    }
  }

  static Future<List<Carro>> getCarros(String tipo) async {
    try {
      Usuario user = await Usuario.get();
      Map<String, String> headers = {
        "Content-Type": "application/json",
        "Authorization": "Bearer ${user.token}"
      };

      var url = '$api/v2/carros/tipo/$tipo';
      print('Request url:  $url');

      var response = await http.get(url, headers: headers);
      String json = response.body;

      List list = jsonDecode(json);

      return list.map<Carro>((m) => Carro.fromMap(m)).toList();
    } catch (error, exception) {
      print("$error >> $exception");
      throw error;
    }
  }

  static Future<String> getDescription() async {
    var url = 'https://loripsum.net/api';

    print("GET > $url");

    var response = await http.get(url);

    String text = response.body;

    text = text.replaceAll("<p>", "");
    text = text.replaceAll("</p>", "");

    return text;
  }

  static Future<ApiResponse<Carro>> saveCarro(Carro c) async {
    Usuario user = await Usuario.get();
    Map<String, String> headers = {
      "Content-Type": "application/json",
      "Authorization": "Bearer ${user.token}"
    };

    String carro = c.toJson();

    var url = '$api/v2/carros';
    print('Request url:  $url');

    var response = await http.post(url, headers: headers, body: carro);
    Map mapResponse = jsonDecode(response.body);
    if (response.statusCode == 201) {
      Carro carroSaved = Carro.fromMap(mapResponse);
      print(carroSaved.id);
      return ApiResponse.success(carroSaved);
    }
    return ApiResponse.error(mapResponse["error"]);
  }
}
