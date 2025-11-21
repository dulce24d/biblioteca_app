// Proveedores para historial de préstamos (loans).
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/firestore_service.dart';
import '../models/loan.dart';
import 'auth_provider.dart';

final firestoreServiceProvider =
    Provider<FirestoreService>((ref) => FirestoreService());

// Stream: userLoansProvider (escucha cambios en la colección de loans para el usuario).
final userLoansProvider = StreamProvider.autoDispose<List<Loan>>((ref) {
  final authState = ref.watch(authStateProvider);
  final firestore = ref.read(firestoreServiceProvider);
  final user = authState.asData?.value;
  if (user == null) return const Stream.empty();
  return firestore.streamLoansForUser(user.uid);
});

// Actions: historyActionsProvider para añadir y marcar devuelto (markReturned).
final historyActionsProvider =
    Provider<HistoryActions>((ref) => HistoryActions(ref));

class HistoryActions {
  final Ref ref;
  HistoryActions(this.ref);

  Future<void> addLoan(Loan loan) async {
    final firestore = ref.read(firestoreServiceProvider);
    await firestore.saveLoan(loan);
  }

  Future<void> markReturned(String userId, String loanId) async {
    final firestore = ref.read(firestoreServiceProvider);
    await firestore.markReturned(userId, loanId);
  }
}
