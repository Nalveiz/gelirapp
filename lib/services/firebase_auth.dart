import 'package:firebase_auth/firebase_auth.dart';
import 'package:myapp/utils/form_validators.dart';

class FirebaseAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<User?> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      throw AuthErrorHandler.getMessage(e.code);
    } catch (e) {
      throw 'Beklenmeyen bir hata oluştu. Lütfen tekrar deneyin.';
    }
  }

  Future<User?> registerWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      throw AuthErrorHandler.getMessage(e.code);
    } catch (e) {
      throw 'Beklenmeyen bir hata oluştu. Lütfen tekrar deneyin.';
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}
