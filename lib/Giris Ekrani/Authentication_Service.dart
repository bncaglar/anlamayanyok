import 'package:anlamayanyok/Services/DBService.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthenticationService {
  final FirebaseAuth _firebaseAuth;

  AuthenticationService(this._firebaseAuth);

  Stream<User> get authStateChanges => _firebaseAuth.authStateChanges();


  Future<void>signOut()async{
    await _firebaseAuth.signOut();
  }
  Future<String> signIn({String email, String password}) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      return "Signed In";
    } catch (e) {
      return e.message;
    }
  }

  Future<String> signUp(
      {String email, String password, String displayName}) async {
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      _firebaseAuth.currentUser.updateProfile(
          displayName: displayName,
          photoURL: "https://firebasestorage.googleapis.com/v0/b/anlamayanyok-853f1.appspot.com/o/placeholderpp.jpg?alt=media&token=47ca21e5-8e91-472d-a57c-a9287b1857b6");
      String uid = _firebaseAuth.currentUser.uid.toString();
      DBService.instance.createUserInDB(uid, displayName, email,
          "https://firebasestorage.googleapis.com/v0/b/anlamayanyok-853f1.appspot.com/o/placeholderpp.jpg?alt=media&token=47ca21e5-8e91-472d-a57c-a9287b1857b6");

      return "Signed Up";
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }
}
