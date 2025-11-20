import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/auth_service.dart';

// Servicio
final authServiceProvider = Provider<AuthService>((ref) => AuthService());

// Stream del usuario
final authStateProvider = StreamProvider<User?>((ref) {
  final service = ref.read(authServiceProvider);
  return service.authStateChanges();
});

// Notifier con acciones
final authNotifierProvider = Provider<AuthNotifier>((ref) => AuthNotifier(ref));

class AuthNotifier {
  final Ref ref;
  AuthNotifier(this.ref);

  Future<void> signIn(String email, String password) async {
    final srv = ref.read(authServiceProvider);
    await srv.signIn(email, password);
  }

  Future<void> register(String email, String password) async {
    final srv = ref.read(authServiceProvider);
    await srv.register(email, password);
  }

  Future<void> signOut() async {
    final srv = ref.read(authServiceProvider);
    await srv.signOut();
  }

  User? get currentUser => ref.read(authServiceProvider).currentUser();
}
