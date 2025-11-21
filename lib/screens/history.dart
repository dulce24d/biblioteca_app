// lib/screens/history.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/history_provider.dart';
import '../widgets/loan_tile.dart';
import '../providers/auth_provider.dart';

class HistoryScreen extends ConsumerWidget {
  const HistoryScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loansAsync = ref.watch(userLoansProvider);
    final user = ref.watch(authStateProvider).asData?.value;

    return Scaffold(
      appBar: AppBar(title: const Text("Historial de Prestamos")),
      body: loansAsync.when(
        data: (loans) => ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: loans.length,
          itemBuilder: (_, i) {
            final loan = loans[i];
            return Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(loan.bookTitle,
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold)),
                        Text(
                            "Prestado: ${loan.dateStart.toString().substring(0, 10)}"),
                      ],
                    ),
                    loan.returned
                        ? const Icon(Icons.check_circle, color: Colors.green)
                        // <- aquí pasamos la closure que llama al provider
                        : ElevatedButton(
                            onPressed: () {
                              if (user == null) {
                                // opcional: mostrar mensaje o navegar al login
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text('Debes iniciar sesión')),
                                );
                                return;
                              }
                              ref
                                  .read(historyActionsProvider)
                                  .markReturned(user.uid, loan.id);
                            },
                            child: const Text("Devolver"),
                          ),
                  ],
                ),
              ),
            );
          },
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text("Error: $e")),
      ),
    );
  }
}
