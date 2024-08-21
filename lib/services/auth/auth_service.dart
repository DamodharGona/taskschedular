import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'package:taskschedular/core/constants/firebase_constants.dart';
import 'package:taskschedular/core/services/firestore_service.dart';
import 'package:taskschedular/models/user_model.dart';

class AuthService {
  AuthService._privateConstructor();
  static final AuthService instance = AuthService._privateConstructor();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  // GET USER DATA
  // using null check operator since this method should be called only
  // when the user is logged in
  User get user => _auth.currentUser!;

  // STATE PERSISTENCE STREAM
  Stream<User?> get authState => FirebaseAuth.instance.authStateChanges();

  // OTHER WAYS (depends on use case):
  // Stream get authState => FirebaseAuth.instance.userChanges();
  // Stream get authState => FirebaseAuth.instance.idTokenChanges();
  // KNOW MORE ABOUT THEM HERE: https://firebase.flutter.dev/docs/auth/start#auth-state

  // GOOGLE SIGN IN
  Future<void> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      if (googleAuth?.accessToken != null && googleAuth?.idToken != null) {
        // Create a new credential
        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth?.accessToken,
          idToken: googleAuth?.idToken,
        );

        UserCredential userCredential =
            await _auth.signInWithCredential(credential);

        print("userCredential: $userCredential");

        if (userCredential.user != null) {
          if (userCredential.additionalUserInfo!.isNewUser) {
            final user = userCredential.user;
            if (user != null) {
              await FirestoreService.instance.addDocument(
                collection: FirebaseConstants.usersCollection,
                data: UserModel(
                  id: user.uid,
                  emailId: user.email ?? '',
                  mobile: user.phoneNumber ?? '',
                  name: user.displayName ?? '',
                ).toJson(),
              );
            }
          }
        }
      }
    } on FirebaseAuthException catch (e) {
      print("FirebaseAuthException: $e");
      throw Exception(e.message);
    } catch (e, stack) {
      print("error: $e");
      print("stack: $stack");
      throw Exception(e);
    }
  }

  // SIGN OUT
  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message);
    } catch (e) {
      throw Exception(e);
    }
  }
}
