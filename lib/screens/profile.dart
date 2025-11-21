// lib/screens/profile.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/auth_provider.dart';
import 'favorites.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authStateProvider).asData?.value;
    final displayName =
        user?.displayName ?? ''; // nombre proveniente de Firebase Auth
    final email = user?.email ?? '';

    return Scaffold(
      appBar: AppBar(title: const Text('Perfil')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Avatar y nombre
            Row(
              children: [
                CircleAvatar(
                  radius: 36,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.person, size: 36, color: Colors.indigo),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        displayName.isNotEmpty ? displayName : 'Usuario',
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Text(email,
                          style: const TextStyle(color: Colors.black54)),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 30),

            // Botones de acción con separación
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const FavoritesScreen()));
              },
              icon: const Icon(Icons.favorite, color: Colors.red),
              label: const Text('Ver favoritos'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 255, 255, 255),
                minimumSize: const Size.fromHeight(48),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
            ),

            const SizedBox(height: 12),

            const Spacer(), // empuja el botón cerrar sesión al final

            // Botón Cerrar sesión, al final y separado
            ElevatedButton.icon(
              onPressed: () async {
                await ref.read(authNotifierProvider).signOut();
                // opcional: navegar a login y limpiar stack
                Navigator.of(context)
                    .pushNamedAndRemoveUntil('/', (route) => false);
              },
              icon:
                  const Icon(Icons.logout, color: Color.fromARGB(255, 0, 0, 0)),
              label: const Text('Cerrar sesión'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 254, 254, 254),
                minimumSize: const Size.fromHeight(48),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
