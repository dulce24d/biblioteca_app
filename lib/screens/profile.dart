import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/auth_provider.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authStateProvider).asData?.value;

    return Scaffold(
      appBar: AppBar(title: const Text('Perfil')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Correo: ${user?.email ?? 'Anónimo'}'),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () => ref.read(authNotifierProvider).signOut(),
              child: const Text('Cerrar sesión'),
            ),
          ],
        ),
      ),
    );
  }
}
