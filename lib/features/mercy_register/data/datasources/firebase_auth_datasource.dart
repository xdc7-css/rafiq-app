import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAnonymousAuthDataSource {
  final FirebaseAuth _auth;

  FirebaseAnonymousAuthDataSource({FirebaseAuth? auth})
      : _auth = auth ?? FirebaseAuth.instance;

  Future<String?> signInAnonymously() async {
    try {
      final result = await _auth.signInAnonymously();
      return result.user?.uid;
    } catch (_) {
      return null;
    }
  }

  String? get currentUserId => _auth.currentUser?.uid;

  bool get isAuthenticated => _auth.currentUser != null;

  Stream<String?> get authStateChanges =>
      _auth.authStateChanges().map((user) => user?.uid);

  Future<void> signOut() async {
    await _auth.signOut();
  }
}
