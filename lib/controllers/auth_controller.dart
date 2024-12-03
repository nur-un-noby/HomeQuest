import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:realstateclient/core/widgets/show_snackbar.dart';
import 'package:realstateclient/models/user_model.dart';
import 'package:realstateclient/repository/auth_repository.dart';

final userProvider = StateProvider<UserModel?>((ref) => null);

final authControllProvider = StateNotifierProvider<AuthController, bool>(
  (ref) => AuthController(
      authRepository: ref.watch(
        authRepositoryProvider,
      ),
      ref: ref),
);

final authStateChangesProvider = StreamProvider<User?>((ref) {
  final authController = ref.watch(authControllProvider.notifier);
  return authController.authStateChanges;
});

final getUserDataProvider = StreamProvider.family((ref, String uid) {
  final authController = ref.watch(authControllProvider.notifier);
  return authController.getUserData(uid);
});

class AuthController extends StateNotifier<bool> {
  final AuthRepository _authRepository;
  final Ref _ref;
  AuthController({required AuthRepository authRepository, required Ref ref})
      : _authRepository = authRepository,
        _ref = ref,
        super(false);

  Stream<User?> get authStateChanges => _authRepository.authStateChanges;

  void login(BuildContext context, String email, String password) async {
    state = true;
    final res =
        await _authRepository.loginUser(email: email, password: password);
    state = false;
    res.fold((l) {
      showSnackBar(context, l.message);
    }, (r) {
      showSnackBar(context, 'Login Successful');
      _ref.read(userProvider.notifier).update((state) => r);
    });
  }

  void register(BuildContext context, String email, String password,
      String phone, String name) async {
    state = true;

    final res = await _authRepository.registerUser(
        email: email, password: password, phone: phone, name: name);
    state = false;
    res.fold((l) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(l.message),
      ));
    }, (r) {
      showSnackBar(context, 'Register Successful');
      Navigator.of(context).pop();
    });
  }

  Stream<UserModel> getUserData(String uid) {
    return _authRepository.getUserData(uid);
  }

  void logout() async {
    _authRepository.logout();
  }
}
