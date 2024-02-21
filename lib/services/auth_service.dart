import 'package:firebase_auth/firebase_auth.dart';
import 'package:todo_app/models/user.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  UserModel? _userFromFirebase(User? user) {
    return user != null ? UserModel(uid: user.uid) : null;
  }

  Stream<UserModel?> get user =>
      _auth.authStateChanges().map(_userFromFirebase);

  Future signInAnons() async {
    try {
      UserCredential result = await _auth.signInAnonymously();
      return _userFromFirebase(result.user);
    } catch (e) {
      print('SIGN IN ANONS ERRO:$e');
      return null;
    }
  }

  Future registerWithEmailAndPassword(
      {required String email, required String password}) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      return _userFromFirebase(result.user);
    } catch (e) {
      print('REGISTER ERRO:$e');
      return null;
    }
  }

  Future signInWithEmailAndPassword(
      {required String email, required String password}) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      return _userFromFirebase(result.user);
    } catch (e) {
      print('SIGN IN ERROR:$e');
      return null;
    }
  }

  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      return null;
    }
  }
}
