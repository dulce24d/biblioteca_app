// lib/screens/register.dart
import 'package:biblioteca_app/screens/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../providers/auth_provider.dart';
import '../core/utils.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});
  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();
  final nameCtrl = TextEditingController();
  bool loading = false;

  Future<void> _register() async {
    setState(() => loading = true);
    try {
      // crear usuario en Firebase Auth
      final cred = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailCtrl.text.trim(),
        password: passCtrl.text.trim(),
      );

      // actualizar displayName
      await cred.user?.updateDisplayName(nameCtrl.text.trim());

      // crear documento de perfil en Firestore (colección users)
      final userDoc =
          FirebaseFirestore.instance.collection('users').doc(cred.user!.uid);
      await userDoc.set({
        'name': nameCtrl.text.trim(),
        'email': cred.user!.email,
        'createdAt': DateTime.now().toIso8601String(),
      });

      // volver al login o navegar al home
      if (!mounted) return;
      Navigator.of(context).pop();
    } on FirebaseAuthException catch (e) {
      showErrorSnackBar(context, e.message ?? 'Error al registrar');
    } catch (e) {
      showErrorSnackBar(context, e.toString());
    } finally {
      setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Para fondo indigo en esta pantalla:
      body: Container(
        color: Colors.indigo, // fondo indigo
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Card(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    const Text('Crear cuenta',
                        style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.indigo)),
                    const SizedBox(height: 12),
                    TextField(
                        controller: nameCtrl,
                        decoration: const InputDecoration(
                            labelText: 'Nombre completo')),
                    const SizedBox(height: 8),
                    TextField(
                        controller: emailCtrl,
                        decoration: const InputDecoration(labelText: 'Correo')),
                    const SizedBox(height: 8),
                    TextField(
                        controller: passCtrl,
                        decoration:
                            const InputDecoration(labelText: 'Contraseña'),
                        obscureText: true),
                    const SizedBox(height: 16),
                    loading
                        ? const CircularProgressIndicator()
                        : ElevatedButton(
                            onPressed: _register,
                            child: const Text('Crear Cuenta')),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('¿Ya tienes una cuenta?'),
                        TextButton(
                          onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => const LoginScreen())),
                          child: const Text('Iniciar sesión'),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
