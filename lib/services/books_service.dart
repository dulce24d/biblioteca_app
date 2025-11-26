// lib/services/books_service.dart
// Servicio que consulta la API de Google Books para búsquedas y detalles.
// NOTA: **no proxificamos las búsquedas** (funcionan directo desde el navegador).
// Solo proxificamos imágenes en widgets (book_card/book_detail).

import 'package:dio/dio.dart';
import '../models/book.dart';
import '../core/constants.dart';

class BooksService {
  final Dio _dio;

  BooksService({Dio? dio})
      : _dio = dio ??
            Dio(BaseOptions(
              baseUrl: 'https://www.googleapis.com', // base para las búsquedas
              connectTimeout: 10000,
              receiveTimeout: 10000,
            ));

  /// Obtiene detalles de un volumen (JSON) directamente desde Google Books API.
  Future<Book> getVolumeById(String id) async {
    final endpoint = '/books/v1/volumes/$id'; // se usa baseUrl + endpoint
    final resp = await _dio.get(endpoint);
    if (resp.statusCode != 200) {
      throw Exception('Error ${resp.statusCode} al obtener volumen');
    }
    final data = resp.data as Map<String, dynamic>;
    return Book.fromJson(data);
  }

  /// Buscar libros por query (directo). Esto evita problemas al proxificar la API.
  Future<List<Book>> searchBooks(String query,
      {int maxResults = googleBooksMaxResults}) async {
    final q = query.trim();
    if (q.isEmpty) return <Book>[];

    try {
      final resp = await _dio.get('/books/v1/volumes', queryParameters: {
        'q': q,
        'maxResults': maxResults,
      });

      if (resp.statusCode != 200) {
        throw Exception(
            'Google Books API responded with status ${resp.statusCode}');
      }

      final data = resp.data as Map<String, dynamic>? ?? {};
      final items = data['items'] as List<dynamic>? ?? [];
      return items
          .cast<Map<String, dynamic>>()
          .map((m) => Book.fromJson(m))
          .toList();
    } on DioError catch (e) {
      // Manejo claro y diferenciado de errores Dio
      if (e.type == DioErrorType.response) {
        final status = e.response?.statusCode;
        final msg = e.response?.statusMessage ?? e.message;
        throw Exception('HTTP error $status: $msg');
      } else if (e.type == DioErrorType.connectTimeout ||
          e.type == DioErrorType.receiveTimeout) {
        throw Exception('Timeout: ${e.message}');
      } else if (e.type == DioErrorType.cancel) {
        throw Exception('Request cancelled');
      } else {
        throw Exception('HTTP request failed (${e.type}): ${e.message}');
      }
    } catch (e) {
      throw Exception('Error buscando libros: $e');
    }
  }
}
