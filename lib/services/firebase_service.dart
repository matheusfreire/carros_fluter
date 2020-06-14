import 'package:carros/model/usuario.dart';
import 'package:carros/utils/api_response.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FirebaseService {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  loginGoogle() async {
    try {
      final GoogleSignInAccount gUser = await _googleSignIn.signIn();
      final GoogleSignInAuthentication authentication =
          await gUser.authentication;

      print("Google User: ${gUser.email}");

      final AuthCredential credential = GoogleAuthProvider.getCredential(
          idToken: authentication.idToken,
          accessToken: authentication.accessToken);

      AuthResult result = await _auth.signInWithCredential(credential);
      final FirebaseUser fUser = result.user;
      print("Firebase Nome: ${fUser.displayName}");
      print("Firebase Email: ${fUser.email}");
      print("Firebase Foto: ${fUser.photoUrl}");
      final user = Usuario(
        nome: fUser.displayName,
        login: fUser.email,
        email: fUser.email,
        urlFoto: fUser.photoUrl,
      );
      user.save();

      // Resposta genérica
      return ApiResponse.success();
    } catch (error) {
      print("Firebase error $error");
      return ApiResponse.error(msg: "Não foi possível fazer o login");
    }
  }

  Future<ApiResponse> loginByMail(String email, String password) async {
    try {
      AuthResult result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      final FirebaseUser fUser = result.user;
      print("Firebase Nome: ${fUser.displayName}");
      print("Firebase Email: ${fUser.email}");
      print("Firebase Foto: ${fUser.photoUrl}");
      final user = Usuario(
        nome: fUser.displayName,
        login: fUser.email,
        email: fUser.email,
        urlFoto: fUser.photoUrl,
      );
      user.save();

      // Resposta genérica
      return ApiResponse.success();
    } catch (error) {
      print("Firebase error $error");
      return ApiResponse.error(msg: "Não foi possível fazer o login");
    }
  }

  signOut() {
    _googleSignIn.signOut();
    _auth.signOut();
  }

  Future<ApiResponse> cadastrar(String nome, String email, String senha) async {
    try {
      AuthResult result = await _auth.createUserWithEmailAndPassword(
          email: email, password: senha);
      final FirebaseUser fUser = result.user;
      print("Firebase Nome: ${fUser.displayName}");
      print("Firebase Email: ${fUser.email}");
      print("Firebase Foto: ${fUser.photoUrl}");

      final userUpdateInfo = UserUpdateInfo();
      userUpdateInfo.displayName = nome;
      userUpdateInfo.photoUrl = "https://www.google.com/url?sa=i&url=https%3A%2F%2Fwww.stickpng.com%2Fimg%2Ficons-logos-emojis%2Fusers%2Fsimple-user-icon&psig=AOvVaw2C_-tC-myY9ZdCb9Nfniqy&ust=1592259266684000&source=images&cd=vfe&ved=0CAIQjRxqFwoTCMDfuJKqguoCFQAAAAAdAAAAABAI";
      fUser.updateProfile(userUpdateInfo);

      return ApiResponse.success(msg: "Usuário criado com sucesso");
    } catch (error) {
      print(error);
      if(error is PlatformException){
        print("Error code ${error.code}");

        return ApiResponse.error(msg: "Erro ao criar um usuário. \n\n${error.message}");
      }

      return ApiResponse.error(msg: "Não foi possível criar um usuário");
    }
  }
}
