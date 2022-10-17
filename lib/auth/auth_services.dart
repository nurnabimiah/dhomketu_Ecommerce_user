
import 'package:firebase_auth/firebase_auth.dart';

class AuthServices {

  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static User? get currentUser => _auth.currentUser;

  static Future<User?> loginUser(String email, String pass) async{
    final credential = await _auth.signInWithEmailAndPassword(email: email, password: pass);
    return credential.user;
  }
  

   static Future <User?> registerUser(String email, String pass) async{
    final creadential = await _auth.createUserWithEmailAndPassword(email: email, password: pass);
    return creadential.user;
   }
  static Future<void> logOut(){
    return _auth.signOut();
  }


}