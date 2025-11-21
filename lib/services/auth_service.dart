import 'package:firebase_auth/firebase_auth.dart';

// Servicio wrapper sobre FirebaseAuth para encapsular llamadas de autenticación.
// Esto permite que los providers llamen a AuthService en lugar de depender directamente de FirebaseAuth.
class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Stream que notifica cambios de sesión (login/logout)
  Stream<User?> authStateChanges() => _auth.authStateChanges();

  // Devuelve el usuario actual (si hay)
  User? currentUser() => _auth.currentUser;

  // Iniciar sesión: devuelve UserCredential (cuidado con errores)
  Future<UserCredential> signIn(String email, String password) =>
      _auth.signInWithEmailAndPassword(email: email, password: password);

  // Registrar nuevo usuario: devuelve UserCredential
  Future<UserCredential> register(String email, String password) =>
      _auth.createUserWithEmailAndPassword(email: email, password: password);

  // Cerrar sesión
  Future<void> signOut() => _auth.signOut();
}
