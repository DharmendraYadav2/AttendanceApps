import 'package:flutter_riverpod/legacy.dart';
import 'package:tutionsapp/Service/Firebase/app_firebase.dart';
import 'package:tutionsapp/Service/Firebase/providers/signup.dart';

final authcontrollerprovider = StateNotifierProvider<authcontroller, bool>((
  ref,
) {
  final repo = ref.watch(authrepositoryprovider);
  return authcontroller(repo);
});

class authcontroller extends StateNotifier<bool> {
  final AuthRepository _repo;
  authcontroller(this._repo) : super(false);
  Future<void> SignUp({
    required String name,
    required String email,
    required String password,
  }) async {
    state = true;
    try {
      await _repo.signUp(name: name, email: email, password: password);
    } catch (e) {
      state = false;
      rethrow;
    }
    state = false;
  }

  Future<void> loginup({
    required String email,
    required String password,
  }) async {
    state = true;
    try {
      await _repo.loginup(email: email, password: password);
    } catch (e) {
      state = false;
      rethrow;
    }
    state = false;
  }
}
