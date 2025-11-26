// lib/screens/book_detail_placeholder.dart
// Pantalla de detalle del libro con portada (proxificada), título, autores,
// descripción, botón "Solicitar préstamo" y corazón para favoritos.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../models/book.dart';
import '../core/constants.dart';
import '../providers/history_provider.dart';
import '../providers/favorites_provider.dart';
import '../providers/auth_provider.dart';
import '../models/loan.dart';

class BookDetailScreen extends ConsumerWidget {
  final Book book;
  const BookDetailScreen({required this.book, Key? key}) : super(key: key);

  String _ensureHttps(String url) {
    if (url.startsWith('http://'))
      return url.replaceFirst('http://', 'https://');
    return url;
  }

  String _proxiedImageUrl(String rawUrl) {
    if (rawUrl.isEmpty) return '';
    final fixed = _ensureHttps(rawUrl);
    if (corsProxy == null || corsProxy!.isEmpty) return fixed;
    final encoded = Uri.encodeComponent(fixed);
    return '${corsProxy!}?url=$encoded';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authStateProvider).asData?.value;
    final favsAsync = ref.watch(userFavoritesProvider);
    final isFav = favsAsync.maybeWhen(
      data: (list) => list.any((b) => b.id == book.id),
      orElse: () => false,
    );

    final imageUrl = _proxiedImageUrl(book.thumbnail ?? '');

    return Scaffold(
      appBar: AppBar(title: Text(book.title, overflow: TextOverflow.ellipsis)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          if (imageUrl.isNotEmpty)
            Center(
              child: ConstrainedBox(
                constraints:
                    const BoxConstraints(maxHeight: 320, maxWidth: 220),
                child: CachedNetworkImage(
                  imageUrl: imageUrl,
                  placeholder: (c, u) => const SizedBox(
                      height: 200,
                      child: Center(child: CircularProgressIndicator())),
                  errorWidget: (c, u, e) => const SizedBox(
                      height: 200,
                      child: Center(child: Icon(Icons.broken_image, size: 48))),
                  fit: BoxFit.contain,
                ),
              ),
            ),
          const SizedBox(height: 12),
          Text(book.title,
              style:
                  const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text('Autores: ${book.authors.join(', ')}',
              style: const TextStyle(color: Colors.black54)),
          const SizedBox(height: 12),
          if (book.description.isNotEmpty)
            Text(book.description)
          else
            const Text('Sin descripción disponible',
                style: TextStyle(color: Colors.black45)),
          const SizedBox(height: 20),

          // Acciones: Solicitar préstamo + Favorito
          Row(children: [
            Expanded(
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(48)),
                icon: const Icon(Icons.shopping_basket_outlined),
                label: const Text('Solicitar préstamo'),
                onPressed: () async {
                  if (user == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text(
                              'Debes iniciar sesión para solicitar un préstamo')),
                    );
                    return;
                  }

                  try {
                    final loan = Loan(
                      id: '',
                      bookId: book.id,
                      bookTitle: book.title,
                      userId: user.uid,
                      dateStart: DateTime.now(),
                      dateEnd: null,
                      returned: false,
                    );
                    await ref.read(historyActionsProvider).addLoan(loan);
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text('Préstamo solicitado correctamente')));
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text('Error al solicitar préstamo: $e')));
                  }
                },
              ),
            ),
            const SizedBox(width: 12),
            // Icono favorito que consulta el stream userFavoritesProvider
            IconButton(
              icon: Icon(isFav ? Icons.favorite : Icons.favorite_border),
              color: Colors.redAccent,
              iconSize: 30,
              onPressed: () async {
                if (user == null) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content:
                          Text('Debes iniciar sesión para marcar favorito')));
                  return;
                }
                try {
                  if (isFav) {
                    await ref
                        .read(favoritesActionsProvider)
                        .removeFavorite(book.id);
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text('Eliminado de favoritos')));
                  } else {
                    await ref.read(favoritesActionsProvider).addFavorite(book);
                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Agregado a favoritos')));
                  }
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error en favoritos: $e')));
                }
              },
            ),
          ]),
        ]),
      ),
    );
  }
}
