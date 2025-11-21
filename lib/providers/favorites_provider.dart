// Proveedores para manejar favoritos: stream (userFavoritesProvider) y acciones (favoritesActionsProvider).

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/firestore_service.dart';
import '../models/book.dart';
import 'auth_provider.dart';

final firestoreServiceProvider =
    Provider<FirestoreService>((ref) => FirestoreService());

/// Stream de favoritos del usuario actual
final userFavoritesProvider = StreamProvider.autoDispose<List<Book>>((ref) {
  final authState = ref.watch(authStateProvider);
  final fs = ref.read(firestoreServiceProvider);
  final user = authState.asData?.value;
  if (user == null) return const Stream.empty();
  return fs.streamFavoritesForUser(user.uid);
});

/// Acciones para agregar/quitar favoritos
final favoritesActionsProvider =
    Provider<FavoritesActions>((ref) => FavoritesActions(ref));

class FavoritesActions {
  final Ref ref;
  FavoritesActions(this.ref);

  Future<void> addFavorite(Book book) async {
    final user = ref.read(authStateProvider).asData?.value;
    if (user == null) throw Exception('Usuario no autenticado');
    final fs = ref.read(firestoreServiceProvider);
    await fs.addFavorite(user.uid, book);
  }

  Future<void> removeFavorite(String bookId) async {
    final user = ref.read(authStateProvider).asData?.value;
    if (user == null) throw Exception('Usuario no autenticado');
    final fs = ref.read(firestoreServiceProvider);
    await fs.removeFavorite(user.uid, bookId);
  }

  Future<bool> isFavorite(String bookId) async {
    final user = ref.read(authStateProvider).asData?.value;
    if (user == null) return false;
    final fs = ref.read(firestoreServiceProvider);
    return await fs.isFavorite(user.uid, bookId);
  }
}
