import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:zipzop/models/localUser.dart';

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final googleSignIn = GoogleSignIn();

  GoogleSignInAccount? _user;
  GoogleSignInAccount get user => _user!;

  LocalUser? _userFromFirebaseUser(User? user) {
    return user != null ? LocalUser(userId: user.uid) : null;
  }

  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential credential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User? user = credential.user;
      return _userFromFirebaseUser(user);
    } catch (error) {
      print(error.toString());
    }
  }

  Future callGoogleSingIn() async {
    try{
      final googleUser = await googleSignIn.signIn();

      if(googleUser == null){
        return;
      }
      _user = googleUser;

      final googleAuth = await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential credentials = await _auth.signInWithCredential(credential);

      return _userFromFirebaseUser(credentials.user);
    }catch (error){
      print("googlesingin " + error.toString());
    }
  }

  Future singUpWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential credential = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User? user = credential.user;
      return _userFromFirebaseUser(user);
    } catch (error) {
      print("singup " + error.toString());
    }
  }

  Future resetPassword(String email) async{
    try{
      return await _auth.sendPasswordResetEmail(email: email);
    }catch (error) {
      print(error.toString());
    }
  }

  Future singOut() async {
    try{
      await googleSignIn.disconnect();
      return await _auth.signOut();
    }catch (error) {
      print("singout" + error.toString());
    }
  }
}
