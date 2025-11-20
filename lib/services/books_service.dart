import 'package:dio/dio.dart';
import '../models/book.dart';
import '../core/constants.dart';

class BooksService {
  final Dio _dio = Dio();

  // Busca en Google Books. Puedes añadir apiKey si tienes.
  Future<List<Book>> searchBooks(String query,
      {int maxResults = googleBooksMaxResults}) async {
    final q = Uri.encodeQueryComponent(query);
    final url =
        'https://www.googleapis.com/books/v1/volumes?q=$q&maxResults=$maxResults';
    final resp = await _dio.get(url);
    if (resp.statusCode != 200) throw Exception('Error Google Books API');
    final data = resp.data as Map<String, dynamic>;
    final items = data['items'] as List<dynamic>? ?? [];
    return items
        .cast<Map<String, dynamic>>()
        .map((m) => Book.fromJson(m))
        .toList();
  }
}
