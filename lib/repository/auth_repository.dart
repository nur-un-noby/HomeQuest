import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:realstateclient/core/constants/collection_constants.dart';
import 'package:realstateclient/core/type_def.dart';
import 'package:realstateclient/core/widgets/failure.dart';
import 'package:realstateclient/models/user_model.dart';
import 'package:realstateclient/repository/constants_provider.dart';

final authRepositoryProvider = Provider((ref) => (AuthRepository(
      firestore: ref.read(firestoreProvider),
      auth: ref.read(authProvider),
    )));

class AuthRepository {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  AuthRepository({
    required FirebaseFirestore firestore,
    required FirebaseAuth auth,
  })  : _firestore = firestore,
        _auth = auth;

  CollectionReference get _users =>
      _firestore.collection(FirebaseConstants.usersCollection);

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  Stream<UserModel> getUserData(String uid) {
    return _users.doc(uid).snapshots().map(
        (event) => UserModel.fromMap(event.data() as Map<String, dynamic>));
  }

  void logout() async {
    await _auth.signOut();
  }

  FutureEither<UserModel> loginUser({
    required String email,
    required String password,
  }) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      // Get user details from Firestore
      final userDoc = await _users.doc(_auth.currentUser!.uid).get();
      final user = UserModel.fromMap(userDoc.data() as Map<String, dynamic>);
      return right(user);
      // No error
    } on FirebaseAuthException catch (e) {
      return left(Failure(e.message.toString()));
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  FutureVoid registerUser({
    required String name,
    required String email,
    required String phone,
    required String password,
  }) async {
    try {
      // Create user with email and password
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Save user details to Firestore
      UserModel userModel = UserModel(
        uid: userCredential.user!.uid,
        name: name,
        email: email,
        phoneNumber: phone,
      );
      await _users.doc(userModel.uid).set(userModel.toMap());
      return right(null); // No error
    } on FirebaseAuthException catch (e) {
      // Handle FirebaseAuth errors
      return left(Failure(e.message.toString()));
    } catch (e) {
      // Handle other errors
      return left(Failure(e.toString()));
    }
  }


}
