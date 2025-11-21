// lib/screens/book_detail_placeholder.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../models/book.dart';
import '../core/constants.dart';
import '../providers/history_provider.dart';
import '../providers/favorites_provider.dart';
import '../providers/auth_provider.dart'; // <-- IMPORT NECESARIO
import '../models/loan.dart';
import '../core/utils.dart';

class BookDetailScreen extends ConsumerWidget {
  final Book book;
  const BookDetailScreen({required this.book, Key? key}) : super(key: key);

  String _proxiedImageUrl(String rawUrl) {
    if (rawUrl.isEmpty) return '';
    var fixed = rawUrl;
    if (fixed.startsWith('http://'))
      fixed = fixed.replaceFirst(RegExp(r'^http:'), 'https:');
    if (corsProxy != null && corsProxy!.isNotEmpty) {
      return '${corsProxy!}/${Uri.encodeFull(fixed)}';
    }
    return fixed;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Aquí usamos authStateProvider, por eso es necesario importar auth_provider.dart
    final user = ref.watch(authStateProvider).asData?.value;
    final imageUrl = _proxiedImageUrl(book.thumbnail);

    return Scaffold(
      appBar: AppBar(title: Text(book.title)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (imageUrl.isNotEmpty)
              Center(
                child: ConstrainedBox(
                  constraints:
                      const BoxConstraints(maxHeight: 320, maxWidth: 220),
                  child: CachedNetworkImage(
                    imageUrl: imageUrl,
                    placeholder: (c, url) => const SizedBox(
                        height: 200,
                        child: Center(child: CircularProgressIndicator())),
                    errorWidget: (c, url, e) => const SizedBox(
                      height: 200,
                      child: Center(
                          child: Icon(Icons.broken_image,
                              size: 48, color: Colors.black26)),
                    ),
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
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                        minimumSize: const Size.fromHeight(48)),
                    icon: const Icon(Icons.shopping_basket_outlined),
                    label: const Text('Solicitar préstamo'),
                    onPressed: () async {
                      if (user == null) {
                        showErrorSnackBar(context,
                            'Debes iniciar sesión para solicitar un préstamo');
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
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content:
                                    Text('Préstamo solicitado correctamente')));
                      } catch (e) {
                        showErrorSnackBar(
                            context, 'Error al solicitar préstamo: $e');
                      }
                    },
                  ),
                ),
                const SizedBox(width: 12),
                // Botón favorito
                Consumer(
                  builder: (c, ref2, _) {
                    final favsAsync = ref2.watch(userFavoritesProvider);
                    final isFav =
                        favsAsync.asData?.value.any((b) => b.id == book.id) ??
                            false;
                    return IconButton(
                      icon: Icon(isFav ? Icons.favorite : Icons.favorite_border,
                          color: Colors.redAccent),
                      iconSize: 28,
                      onPressed: () async {
                        if (user == null) {
                          showErrorSnackBar(context,
                              'Debes iniciar sesión para marcar favorito');
                          return;
                        }
                        try {
                          if (isFav) {
                            await ref2
                                .read(favoritesActionsProvider)
                                .removeFavorite(book.id);
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('Eliminado de favoritos')));
                          } else {
                            await ref2
                                .read(favoritesActionsProvider)
                                .addFavorite(book);
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('Agregado a favoritos')));
                          }
                        } catch (e) {
                          showErrorSnackBar(context, 'Error en favoritos: $e');
                        }
                      },
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
