import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/book.dart';
import '../core/constants.dart';
import '../screens/book_detail_placeholder.dart'; // o tu pantalla de detalle real

/// Tarjeta que muestra miniatura, título y autores.
/// Si corsProxy está configurado en core/constants.dart, las URLs de imagen
/// se encaminarán por el proxy para evitar bloqueos CORS en Flutter Web.
class BookCard extends StatelessWidget {
  final Book book;
  final VoidCallback? onTap;

  const BookCard({required this.book, this.onTap, Key? key}) : super(key: key);

  /// Construye la URL final de la imagen, usando el proxy si está activo.
  String _proxiedImageUrl(String rawUrl) {
    if (rawUrl.isEmpty) return '';
    // Si corsProxy no es null, añadimos proxy + URL codificada.
    if (corsProxy != null && corsProxy!.isNotEmpty) {
      // cors-anywhere espera la URL absoluta completa tras el proxy.
      // Aseguramos codificar la URL original para evitar caracteres inválidos.
      return '${corsProxy!}/${Uri.encodeFull(rawUrl)}';
    }
    // Si no hay proxy, devolvemos la URL original tal cual.
    return rawUrl;
  }

  @override
  Widget build(BuildContext context) {
    final rawThumbnail = book.thumbnail;
    final imageUrl = _proxiedImageUrl(rawThumbnail);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      elevation: 3,
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap ??
            () {
              // Navega al detalle (placeholder); reemplaza si tienes un detalle real.
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => BookDetailScreen(book: book)),
              );
            },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
          child: Row(
            children: [
              // Miniatura (clip para bordes redondeados)
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
                          errorWidget: (context, url, error) {
                            // Si falla la carga (por CORS u otros), mostramos icono fallback.
                            return Container(
                              color: const Color(0xFFF6F6F6),
                              child: const Center(
                                child: Icon(Icons.broken_image,
                                    color: Colors.black26),
                              ),
                            );
                          },
                          fit: BoxFit.cover,
                        ),
                ),
              ),

              const SizedBox(width: 12),

              // Título y autores
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
                    const SizedBox(height: 8),
                    // Descripción corta (opcional)
                    if (book.description.isNotEmpty)
                      Text(
                        book.description,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            fontSize: 12, color: Colors.black45),
                      ),
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
