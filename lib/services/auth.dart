import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Auth {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // USER STREAM
  Stream<User?> get user {
    return _auth.authStateChanges();
  }

  @override
  User? get currentUser => _auth.currentUser;

  @override
  Stream<User?> authStateChanges() => _auth.authStateChanges();

  void _createNewUserInFirestore(String name, String email, String mobile) {
    final User? user = currentUser;
    final CollectionReference<Map<String, dynamic>> usersRef =
        FirebaseFirestore.instance.collection('users');
    usersRef.doc(user?.uid).set({
      'id': user?.uid,
      'name': name,
      'email': email,
      'mobile': mobile,
      // 'timestamp': documentIdFromCurrentDate(),
    });
  }

  // SIGN IN WITH EMAIL AND PASSWORD
  Future signIn(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User? user = result.user;
      return user;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // REGISTER WITH EMAIL AND PASSWORD
  Future register(
      String email, String password, String name, String mobile) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User? user = result.user;
      _createNewUserInFirestore(name, email, mobile);
      return user;
    } catch (e) {
      // ignore: avoid_print
      print(e.toString());
    }
  }

  //SIGN OUT
  Future signOutFunction() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      // ignore: avoid_print
      print(e.toString());
      return null;
    }
  }
}
