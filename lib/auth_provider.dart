import 'package:firebase_auth/firebase_auth.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_provider.g.dart';

@riverpod
class Auth extends _$Auth {
  final FirebaseAuth _instance = FirebaseAuth.instance;
  signIn() async => await _instance.signInWithPopup(GoogleAuthProvider());
  signOut() async => await _instance.signInAnonymously();

  @override
  Future<User?> build() async {
    if (_instance.currentUser == null) _instance.signInAnonymously();
    _instance.authStateChanges().listen((event) => state = AsyncValue.data(event));
    return _instance.currentUser!;
  }
}
