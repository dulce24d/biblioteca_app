// lib/widgets/book_card.dart
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/book.dart';
import '../core/constants.dart';
import '../screens/book_detail_placeholder.dart';

/// Tarjeta que muestra miniatura, título y autores.
/// Si `corsProxy` está configurado, la miniatura se proxifica mediante `?url=...`.
class BookCard extends StatelessWidget {
  final Book book;
  final VoidCallback? onTap;

  const BookCard({required this.book, this.onTap, Key? key}) : super(key: key);

  // Asegura https en la URL original (evita mezclas http/https)
  String _ensureHttps(String url) {
    if (url.startsWith('http://'))
      return url.replaceFirst('http://', 'https://');
    return url;
  }

  // Construye la URL final proxificada si corsProxy está configurado.
  // Usa Uri.encodeComponent para que los parámetros queden seguros.
  String _proxiedImageUrl(String rawUrl) {
    if (rawUrl.isEmpty) return '';
    final fixed = _ensureHttps(rawUrl);
    if (corsProxy == null || corsProxy!.isEmpty) return fixed;
    final encoded = Uri.encodeComponent(fixed);
    // El proxy espera ?url=<encoded>
    return '${corsProxy!}?url=$encoded';
  }

  @override
  Widget build(BuildContext context) {
    final rawThumbnail = book.thumbnail ?? '';
    final imageUrl = _proxiedImageUrl(rawThumbnail);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      elevation: 3,
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap ??
            () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => BookDetailScreen(book: book)),
              );
            },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
          child: Row(
            children: [
              // Miniatura (si falla, mostramos icono fallback)
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: SizedBox(
                  width: 56,
                  height: 82,
                  child: imageUrl.isEmpty
                      ? Container(
                          color: const Color(0xFFF0F0F0),
                          child: const Icon(Icons.menu_book,
                              size: 30, color: Colors.black38),
                        )
                      : CachedNetworkImage(
                          imageUrl: imageUrl,
                          placeholder: (context, url) => Container(
                            color: const Color(0xFFF6F6F6),
                            child: const Center(
                                child:
                                    CircularProgressIndicator(strokeWidth: 2)),
                          ),
                          errorWidget: (context, url, error) => Container(
                            color: const Color(0xFFF6F6F6),
                            child: const Center(
                                child: Icon(Icons.broken_image,
                                    color: Colors.black26)),
                          ),
                          fit: BoxFit.cover,
                        ),
                ),
              ),

              const SizedBox(width: 12),

              // Texto: título / autores / descripción corta
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      book.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      book.authors.isNotEmpty
                          ? book.authors.join(', ')
                          : 'Autor desconocido',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style:
                          const TextStyle(fontSize: 13, color: Colors.black54),
                    ),
                    if (book.description.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Text(
                        book.description,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            fontSize: 12, color: Colors.black45),
                      ),
                    ],
                  ],
                ),
              ),

              const SizedBox(width: 8),
              const Icon(Icons.chevron_right, color: Colors.black38),
            ],
          ),
        ),
      ),
    );
  }
}
