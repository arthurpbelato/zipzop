import 'package:firebase_auth/firebase_auth.dart';
import 'package:zipzop/models/localUser.dart';

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;

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
      return await _auth.signOut();
    }catch (error) {
      print(error.toString());
    }
  }
}
