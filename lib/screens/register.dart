import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
  bool loading = false;

  Future<void> _register() async {
    setState(() => loading = true);
    try {
      await ref
          .read(authNotifierProvider)
          .register(emailCtrl.text.trim(), passCtrl.text.trim());
      if (!mounted) return;
      Navigator.of(context).pop(); // vuelve al login
    } catch (e) {
      showErrorSnackBar(context, e.toString());
    } finally {
      setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Registrar cuenta')),
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
                    onPressed: _register, child: const Text('Crear cuenta')),
          ],
        ),
      ),
    );
  }
}
