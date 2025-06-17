import 'package:firebase_auth/firebase_auth.dart';

class ChangePasswordRepository {
  final FirebaseAuth _firebaseAuth;

  ChangePasswordRepository({FirebaseAuth? firebaseAuth})
    : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;

  Future<void> changePassword(
    String currentPassword,
    String newPassword,
  ) async {
    final user = _firebaseAuth.currentUser;
    if (user == null || user.email == null) {
      throw Exception('No user logged in');
    }

    final cred = EmailAuthProvider.credential(
      email: user.email!,
      password: currentPassword,
    );

    await user.reauthenticateWithCredential(cred);

    await user.updatePassword(newPassword);
  }
}
