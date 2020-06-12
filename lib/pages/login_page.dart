import 'dart:async';

import 'package:carros/bloc/login_bloc.dart';
import 'package:carros/model/usuario.dart';
import 'package:carros/pages/home_page.dart';
import 'package:carros/services/firebase_service.dart';
import 'package:carros/utils/alert.dart';
import 'package:carros/utils/api_response.dart';
import 'package:carros/utils/nav.dart';
import 'package:carros/widgets/app_button.dart';
import 'package:carros/widgets/app_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth_buttons/flutter_auth_buttons.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _tLogin = TextEditingController();
  final _tSenha = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _focusSenha = FocusNode();

  final _block = LoginBlock();

  @override
  void initState() {
    super.initState();
    Future<Usuario> future = Usuario.get();
    future.then((user) {
      setState(() {
        if (user != null) {
          push(context, HomePage(), pushReplace: true);
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Carros"),
      ),
      body: _body(),
    );
  }

  _body() {
    return Form(
      key: _formKey,
      child: Container(
        padding: EdgeInsets.all(16),
        child: ListView(
          children: <Widget>[
            AppText("Login", "Digite o login",
                tController: _tLogin,
                validator: _validateLogin,
                keyboardType: TextInputType.emailAddress,
                inputAction: TextInputAction.next,
                nextFocus: _focusSenha),
            SizedBox(
              height: 10,
            ),
            AppText("Senha", "Digite a senha",
                password: true,
                tController: _tSenha,
                validator: _validateSenha,
                keyboardType: TextInputType.number,
                inputAction: TextInputAction.done,
                focusNode: _focusSenha),
            SizedBox(
              height: 20,
            ),
            StreamBuilder<bool>(
              initialData: false,
              stream: _block.stream,
              builder: (context, snapshot) {
                return AppButton(
                  "Entrar",
                  onPressed: _onClickLogin,
                  showProgress: snapshot.data,
                );
              },
            ),
            Container(
              height: 46,
              margin: EdgeInsets.only(top: 20),
              child: GoogleSignInButton(
                onPressed: _onClickGoogle,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _onClickGoogle() async {
    final service = FirebaseService();
    ApiResponse response = await service.loginGoogle();

    if (response.success) {
      push(context, HomePage(), pushReplace: true);
    } else {
      alert(context, "Erro", response.msg);
    }
  }

  String _validateLogin(String value) {
    if (value.isEmpty) {
      return "Digite o login";
    }
    return null;
  }

  String _validateSenha(String senha) {
    if (senha.isEmpty) {
      return "Digite a senha";
    }
    if (senha.length < 3) {
      return "A senha precisa ter pelo menos 3 dígitos";
    }
    return null;
  }

  _onClickLogin() async {
    bool formOk = _formKey.currentState.validate();
    if (!formOk) {
      return;
    }
    String login = _tLogin.text;
    String senha = _tSenha.text;
    ApiResponse response = await _block.login(login, senha);
    if (response.success) {
      push(context, HomePage(), pushReplace: true);
    } else {
      alert(context, "Erro", response.msg);
    }
  }

  @override
  void dispose() {
    super.dispose();
    _block.dispose();
  }
}
