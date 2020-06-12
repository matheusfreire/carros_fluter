import 'package:carros/model/usuario.dart';
import 'package:carros/utils/api_response.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
      print("Firebase Nome: " + fUser.displayName);
      print("Firebase Email: " + fUser.email);
      print("Firebase Foto: " + fUser.photoUrl);
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

  signOut(){
    _googleSignIn.signOut();
    _auth.signOut();
  }
}
