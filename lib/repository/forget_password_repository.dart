import 'package:firebase_auth/firebase_auth.dart';

class ForgetPasswordRepository {
  final FirebaseAuth _firebaseAuth;

  ForgetPasswordRepository({FirebaseAuth? firebaseAuth})
    : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;

  Future<void> sendPasswordResetEmail(String email) async {
    await _firebaseAuth.sendPasswordResetEmail(email: email);
  }
}
