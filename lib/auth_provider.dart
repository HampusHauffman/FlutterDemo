import 'package:firebase_auth/firebase_auth.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_provider.g.dart';

@riverpod
class Auth extends _$Auth {
  signIn() async =>
      await FirebaseAuth.instance.signInWithPopup(GoogleAuthProvider());

  signOut() async => await FirebaseAuth.instance.signOut();

  @override
  Future<User?> build() async {
    FirebaseAuth.instance
        .authStateChanges()
        .listen((event) => state = AsyncValue.data(event));

    return FirebaseAuth.instance.currentUser!;
  }
}
