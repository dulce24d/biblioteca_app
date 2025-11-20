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
      appBar: AppBar(title: const Text('Historial de préstamos')),
      body: loansAsync.when(
        data: (loans) {
          if (loans.isEmpty) {
            return const Center(child: Text('No hay préstamos'));
          }
          return ListView.builder(
            itemCount: loans.length,
            itemBuilder: (context, i) => LoanTile(
                loan: loans[i],
                onReturn: (loanId) {
                  if (user != null) {
                    ref
                        .read(historyActionsProvider)
                        .markReturned(user.uid, loanId);
                  }
                }),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
    );
  }
}
