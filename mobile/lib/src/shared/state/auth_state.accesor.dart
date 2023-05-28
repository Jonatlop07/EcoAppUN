import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app_user.dart';
import 'auth_state.provider.dart';

class AuthStateAccessor {
  const AuthStateAccessor(this.ref);
  final Ref ref;

  StateController<AppUser?> getAuthStateController() {
    return ref.watch(authStateProvider.notifier);
  }
}
