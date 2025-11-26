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
      appBar: AppBar(title: const Text("Historial de préstamos")),
      body: loansAsync.when(
        data: (loans) {
          if (loans.isEmpty)
            return const Center(child: Text('No tienes préstamos registrados'));

          return ListView.separated(
            padding: const EdgeInsets.all(12),
            itemCount: loans.length,
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemBuilder: (context, i) {
              final loan = loans[i];

              // Usamos LoanTile (que solo acepta onReturn), no pasamos onTap ahí.
              return LoanTile(
                loan: loan,
                onReturn: loan.returned
                    ? (_) {}
                    : (loanId) async {
                        if (user == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('Debes iniciar sesión')));
                          return;
                        }
                        try {
                          await ref
                              .read(historyActionsProvider)
                              .markReturned(user.uid, loanId);
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content:
                                      Text('Préstamo marcado como devuelto')));
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content:
                                  Text('Error al marcar como devuelto: $e')));
                        }
                      },
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text("Error: $e")),
      ),
    );
  }
}
