import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/history_provider.dart';
import '../widgets/loan_tile.dart';
import '../providers/auth_provider.dart';

class HistoryScreen extends ConsumerWidget {
  const HistoryScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // userLoansProvider es un StreamProvider que expone la lista de préstamos del usuario
    final loansAsync = ref.watch(userLoansProvider);
    // authStateProvider expone el usuario actual (User?) para comprobar permisos
    final user = ref.watch(authStateProvider).asData?.value;

    return Scaffold(
      appBar: AppBar(title: const Text("Historial de Prestamos")),
      body: loansAsync.when(
        // Cuando hay datos, construimos un ListView con tarjetas por préstamo
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
                        // mostramos título y fecha (substring(0,10) para cortar la parte de tiempo)
                        Text(loan.bookTitle,
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold)),
                        Text(
                            "Prestado: ${loan.dateStart.toString().substring(0, 10)}"),
                      ],
                    ),
                    // Si ya fue devuelto mostramos icono, sino botón para marcarlo devuelto
                    loan.returned
                        ? const Icon(Icons.check_circle, color: Colors.green)
                        // <- aquí pasamos la closure que llama al provider
                        : ElevatedButton(
                            onPressed: () {
                              if (user == null) {
                                // Si no hay usuario logueado mostramos un SnackBar
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text('Debes iniciar sesión')),
                                );
                                return;
                              }
                              // Llamamos al provider de acciones para marcar como devuelto
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
        // mientras carga mostramos indicador
        loading: () => const Center(child: CircularProgressIndicator()),
        // en caso de error lo mostramos en la UI
        error: (e, _) => Center(child: Text("Error: $e")),
      ),
    );
  }
}
