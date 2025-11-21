// lib/screens/login.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/auth_provider.dart';
import '../core/utils.dart';
import 'register.dart';
import 'home.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final TextEditingController emailCtrl = TextEditingController();
  final TextEditingController passCtrl = TextEditingController();
  bool loading = false;

  Future<void> _login() async {
    setState(() => loading = true);
    try {
      await ref
          .read(authNotifierProvider)
          .signIn(emailCtrl.text.trim(), passCtrl.text.trim());
      if (!mounted) return;
      // Navegar al Home (reemplaza si tu app usa rutas nombradas)
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const HomeScreen()));
    } catch (e) {
      showErrorSnackBar(context, e.toString());
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  @override
  void dispose() {
    emailCtrl.dispose();
    passCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          AppBar(title: const Text('LibSeek')), // AppBar con nombre de la app
      body: Container(
        color: Colors.indigo, // fondo indigo para toda la pantalla
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Card(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              elevation: 6,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Título dentro de la tarjeta (puede ser del mismo color indigo)
                    const Text(
                      'Iniciar sesión',
                      style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.indigo),
                    ),
                    const SizedBox(height: 12),

                    // Email
                    TextField(
                      controller: emailCtrl,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        labelText: 'Correo electrónico',
                        prefixIcon: Icon(Icons.email),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Contraseña
                    TextField(
                      controller: passCtrl,
                      obscureText: true,
                      decoration: const InputDecoration(
                        labelText: 'Contraseña',
                        prefixIcon: Icon(Icons.lock),
                      ),
                    ),
                    const SizedBox(height: 18),

                    // Botón de Login
                    loading
                        ? const SizedBox(
                            height: 48,
                            child: Center(child: CircularProgressIndicator()))
                        : SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: _login,
                              style: ElevatedButton.styleFrom(
                                minimumSize: const Size.fromHeight(48),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12)),
                              ),
                              child: const Text('Entrar'),
                            ),
                          ),

                    const SizedBox(height: 12),

                    // Link a registro
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('¿No tienes cuenta?'),
                        TextButton(
                          onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => const RegisterScreen())),
                          child: const Text('Crear cuenta'),
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
