// Providers relacionados con autenticación:
//  - authServiceProvider: instancia de AuthService (abstracción de FirebaseAuth)
//  - authStateProvider: stream del usuario actual (User?)
//  - authNotifierProvider: Provider que expone acciones síncronas/async (signIn/register/signOut)

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

  // Delegan en AuthService — buena separación de responsabilidades.
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

  // Getter conveniente para obtener el usuario actual (puede ser null).
  User? get currentUser => ref.read(authServiceProvider).currentUser();
}
