// lib/providers/recommended_provider.dart
import 'dart:math';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/book.dart';
import '../services/books_service.dart';

final booksServiceProvider = Provider<BooksService>((ref) => BooksService());

final recommendedBooksProvider =
    FutureProvider.autoDispose<List<Book>>((ref) async {
  final service = ref.read(booksServiceProvider);

  // lista de queries para recomendaciones (puedes personalizar)
  const seeds = [
    'classic',
    'romance',
    'science',
    'fantasy',
    'mystery',
    'history',
    'art',
    'technology',
    'thriller',
    'biography'
  ];
  final rnd = Random();
  final query = seeds[rnd.nextInt(seeds.length)];

  // buscar con un límite pequeño para recomendados
  try {
    final results = await service.searchBooks(query, maxResults: 10);
    return results;
  } catch (e) {
    // si falla retornamos lista vacía para no romper UI
    return <Book>[];
  }
});
