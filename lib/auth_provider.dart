import 'package:firebase_auth/firebase_auth.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_provider.g.dart';

@riverpod
class Auth extends _$Auth {
  user() => FirebaseAuth.instance.currentUser;

  signIn() async {
    var googleProvider = GoogleAuthProvider();

    await FirebaseAuth.instance.signInWithPopup(googleProvider);
  }

  @override
  FutureOr<User> build() async {
    if (user() == null) await FirebaseAuth.instance.signInAnonymously();
    return user();
  }
}
