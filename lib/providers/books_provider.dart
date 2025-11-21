// Provider para gestionar búsquedas de libros.
// Usa StateNotifier + AsyncValue<List<Book>> para representar loading/data/error.

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../models/book.dart';
import '../services/books_service.dart';

final booksServiceProvider = Provider<BooksService>((ref) => BooksService());

// Provider que expone el estado de búsqueda: AsyncValue<List<Book>>
final booksSearchProvider =
    StateNotifierProvider<BooksSearchNotifier, AsyncValue<List<Book>>>(
  (ref) => BooksSearchNotifier(ref),
);

class BooksSearchNotifier extends StateNotifier<AsyncValue<List<Book>>> {
  final Ref ref;
  BooksSearchNotifier(this.ref)
      : super(const AsyncValue<List<Book>>.data(<Book>[]));

  // Lanza la búsqueda; actualiza el estado a loading/data/error.
  Future<void> search(String query) async {
    if (query.trim().isEmpty) return;
    state = const AsyncValue<List<Book>>.loading();
    try {
      final service = ref.read(booksServiceProvider);
      final res = await service.searchBooks(query);
      state = AsyncValue.data(res);
    } catch (e, st) {
      // Guardamos el error para que la UI lo muestre de forma adecuada.
      state = AsyncValue.error(e, st);
    }
  }

  // Limpia resultados (estado a lista vacía).
  void clear() => state = const AsyncValue<List<Book>>.data(<Book>[]);
}
