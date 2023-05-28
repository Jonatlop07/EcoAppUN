import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app_user.dart';

final StateProvider<AppUser?> authStateProvider = StateProvider<AppUser?>((_) => null);
