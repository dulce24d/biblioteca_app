import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/auth_provider.dart';
import 'register.dart';
import 'home.dart';
import '../core/utils.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});
  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();
  bool loading = false;

  Future<void> _login() async {
    setState(() => loading = true);
    try {
      await ref
          .read(authNotifierProvider)
          .signIn(emailCtrl.text.trim(), passCtrl.text.trim());
      if (!mounted) return;
      // Al iniciar sesión, la app (main) debe escuchar authStateProvider y redirigir.
      // Aquí navegamos a Home por si lo prefieres:
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const HomeScreen()));
    } catch (e) {
      showErrorSnackBar(context, e.toString());
    } finally {
      setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Iniciar sesión')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
                controller: emailCtrl,
                decoration: const InputDecoration(labelText: 'Correo')),
            const SizedBox(height: 8),
            TextField(
                controller: passCtrl,
                decoration: const InputDecoration(labelText: 'Contraseña'),
                obscureText: true),
            const SizedBox(height: 16),
            loading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: _login, child: const Text('Entrar')),
            TextButton(
                onPressed: () => Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const RegisterScreen())),
                child: const Text('Crear cuenta')),
          ],
        ),
      ),
    );
  }
}
