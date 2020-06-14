import 'package:carros/pages/home_page.dart';
import 'package:carros/pages/login_page.dart';
import 'package:carros/services/firebase_service.dart';
import 'package:carros/utils/alert.dart';
import 'package:carros/utils/nav.dart';
import 'package:flutter/material.dart';

class CadastroPage extends StatefulWidget {
  @override
  _CadastroPageState createState() => _CadastroPageState();
}

class _CadastroPageState extends State<CadastroPage> {
  final _tNome = TextEditingController();
  final _tEmail = TextEditingController();
  final _tSenha = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _progress = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Cadastre-se"),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: _body(context),
      ),
    );
  }

  _body(BuildContext context) {
    return Form(
      key: _formKey,
      child: ListView(
        children: <Widget>[
          TextFormField(
            controller: _tNome,
            validator: _validateNome,
            keyboardType: TextInputType.text,
            style: TextStyle(
              color: Colors.blue,
              fontSize: 22,
            ),
            decoration: InputDecoration(
              labelText: "Nome",
              labelStyle: TextStyle(
                color: Colors.black,
                fontSize: 22,
              ),
              hintText: "Digite o seu nome",
              hintStyle: TextStyle(
                color: Colors.black,
                fontSize: 18,
              ),
            ),
          ),
          TextFormField(
            controller: _tEmail,
            validator: _validateEmail,
            keyboardType: TextInputType.emailAddress,
            style: TextStyle(
              color: Colors.blue,
              fontSize: 22,
            ),
            decoration: InputDecoration(
              labelText: "Email",
              labelStyle: TextStyle(
                color: Colors.black,
                fontSize: 22,
              ),
              hintText: "Digite seu email",
              hintStyle: TextStyle(
                color: Colors.black,
                fontSize: 18,
              ),
            ),
          ),
          TextFormField(
            controller: _tSenha,
            validator: _validateSenha,
            keyboardType: TextInputType.number,
            obscureText: true,
            style: TextStyle(
              color: Colors.blue,
              fontSize: 22,
            ),
            decoration: InputDecoration(
              labelText: "Senha",
              labelStyle: TextStyle(
                color: Colors.black,
                fontSize: 22,
              ),
              hintText: "Digite sua senha",
              hintStyle: TextStyle(
                color: Colors.black,
                fontSize: 18,
              ),
            ),
          ),
          Container(
            height: 46,
            margin: EdgeInsets.all(20),
            child: RaisedButton(
              color: Colors.blue,
              child: _progress
                  ? CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation(Colors.white),
                    )
                  : Text(
                      "Cadastrar",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                      ),
                    ),
              onPressed: () {
                _onClickCadastrar(context);
              },
            ),
          ),
          Container(
            height: 46,
            margin: EdgeInsets.all(20),
            child: RaisedButton(
              color: Colors.white,
              child: Text(
                "Cancelar",
                style: TextStyle(
                  color: Colors.blue,
                  fontSize: 22,
                ),
              ),
              onPressed: () {
                _onClickCancelar(context);
              },
            ),
          ),
        ],
      ),
    );
  }

  String _validateNome(String value) {
    if (value.isEmpty) {
      return "Informe o nome";
    }
    return null;
  }

  String _validateEmail(String value) {
    if (value.isEmpty) {
      return "Informe seu email";
    }
    return null;
  }

  _onClickCadastrar(BuildContext context) async {
    print("Cadastrar!");

    String nome = _tNome.text;
    String email = _tEmail.text;
    String senha = _tSenha.text;

    print("Nome $nome, Email $email, Senha $senha");

    if (!_formKey.currentState.validate()) {
      return;
    }

    setState(() {
      _progress = true;
    });

    final service = FirebaseService();
    final response = await service.cadastrar(nome, email, senha);

    if (response.success) {
      push(context, HomePage(), pushReplace: true);
    } else {
      alert(context, "Erro",response.msg);
    }

    setState(() {
      _progress = false;
    });
  }

  _onClickCancelar(BuildContext context) {
    push(context, LoginPage(), pushReplace: true);
  }

  String _validateSenha(String value) {
    if(value.isEmpty){
      return "Informe sua senha";
    }
    if(value.length <= 2){
      return "Senha precisa ter mais de 2 números";
    }
    return null;
  }
}
