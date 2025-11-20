import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../models/book.dart';
import '../services/books_service.dart';

// Proveedor del servicio que realiza las búsquedas
final booksServiceProvider = Provider<BooksService>((ref) => BooksService());

// StateNotifierProvider que expone AsyncValue<List<Book>>
final booksSearchProvider =
    StateNotifierProvider<BooksSearchNotifier, AsyncValue<List<Book>>>(
  (ref) => BooksSearchNotifier(ref),
);

class BooksSearchNotifier extends StateNotifier<AsyncValue<List<Book>>> {
  final Ref ref;

  // Inicializamos el estado explícitamente con tipo List<Book>
  BooksSearchNotifier(this.ref)
      : super(const AsyncValue<List<Book>>.data(<Book>[]));

  /// Ejecuta la búsqueda y actualiza el estado.
  Future<void> search(String query) async {
    if (query.trim().isEmpty) return;

    // Marca como loading (con tipo explícito)
    state = const AsyncValue<List<Book>>.loading();

    try {
      final service = ref.read(booksServiceProvider);
      final List<Book> res = await service.searchBooks(query);
      state = AsyncValue.data(res);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  /// Opcional: limpiar resultados
  void clear() {
    state = const AsyncValue<List<Book>>.data(<Book>[]);
  }
}
