import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HistoryRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> addHistory(String viewedUserId) async {
    final currentUser = _auth.currentUser;
    if (currentUser == null) return;

    await _firestore
        .collection('history')
        .doc(currentUser.uid)
        .collection('entries')
        .add({
          'userId': viewedUserId,
          'timestamp': FieldValue.serverTimestamp(),
        });
  }

  Stream<List<Map<String, dynamic>>> getUserHistory() {
    final currentUser = _auth.currentUser;
    if (currentUser == null) {
      return const Stream.empty();
    }

    return _firestore
        .collection('history')
        .doc(currentUser.uid)
        .collection('entries')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => doc.data()).toList());
  }
}
