import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../models/book.dart';
import '../services/books_service.dart';

final booksServiceProvider = Provider<BooksService>((ref) => BooksService());

final booksSearchProvider =
    StateNotifierProvider<BooksSearchNotifier, AsyncValue<List<Book>>>(
  (ref) => BooksSearchNotifier(ref),
);

class BooksSearchNotifier extends StateNotifier<AsyncValue<List<Book>>> {
  final Ref ref;
  BooksSearchNotifier(this.ref)
      : super(const AsyncValue<List<Book>>.data(<Book>[]));

  Future<void> search(String query) async {
    if (query.trim().isEmpty) return;
    state = const AsyncValue<List<Book>>.loading();
    try {
      final service = ref.read(booksServiceProvider);
      final res = await service.searchBooks(query);
      state = AsyncValue.data(res);
    } catch (e, st) {
      // Guárdalo como error (UI mostrará un mensaje central en lugar de N tarjetas de error)
      state = AsyncValue.error(e, st);
    }
  }

  void clear() => state = const AsyncValue<List<Book>>.data(<Book>[]);
}
