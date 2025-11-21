import 'package:dio/dio.dart';
import '../models/book.dart';
import '../core/constants.dart';

class BooksService {
  final Dio _dio;

  BooksService({Dio? dio})
      : _dio = dio ??
            Dio(BaseOptions(
              baseUrl:
                  'https://www.googleapis.com', // base por defecto si no usas proxy
              connectTimeout: 10000,
              receiveTimeout: 10000,
            ));

  Future<Book> getVolumeById(String id) async {
    final String url = corsProxy != null
        ? '${corsProxy!}/https://www.googleapis.com/books/v1/volumes/$id'
        : '/books/v1/volumes/$id';
    final resp = await _dio.get(url);
    if (resp.statusCode != 200) throw Exception('Error ${resp.statusCode}');
    final data = resp.data as Map<String, dynamic>;
    return Book.fromJson(data);
  }

  Future<List<Book>> searchBooks(String query, {int maxResults = 20}) async {
    final q = query.trim();
    if (q.isEmpty) return <Book>[];

    try {
      // Si corsProxy está activo, construimos la URL completa apuntando al proxy
      // cors-anywhere espera: https://cors-anywhere.herokuapp.com/https://www.googleapis.com/books/v1/volumes
      final String url;
      if (corsProxy != null) {
        url = '${corsProxy}/https://www.googleapis.com/books/v1/volumes';
      } else {
        url = '/books/v1/volumes';
      }

      final resp = await _dio.get(
        url,
        queryParameters: {
          'q': q,
          'maxResults': maxResults,
        },
      );

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
