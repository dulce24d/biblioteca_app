// lib/screens/favorites.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../models/book.dart';
import '../providers/favorites_provider.dart';
import '../providers/auth_provider.dart';
import '../core/constants.dart';
import 'book_detail_placeholder.dart'; // tu pantalla de detalle

class FavoritesScreen extends ConsumerWidget {
  const FavoritesScreen({Key? key}) : super(key: key);

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

  Widget _favCard(BuildContext context, WidgetRef ref, Book book) {
    final img = _proxiedImageUrl(book.thumbnail);

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      elevation: 4,
      child: InkWell(
        onTap: () => Navigator.push(context,
            MaterialPageRoute(builder: (_) => BookDetailScreen(book: book))),
        borderRadius: BorderRadius.circular(14),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: SizedBox(
                  width: 70,
                  height: 98,
                  child: img.isEmpty
                      ? Container(
                          color: const Color(0xFFF6F6F6),
                          child: const Icon(Icons.menu_book,
                              size: 34, color: Colors.black38))
                      : CachedNetworkImage(
                          imageUrl: img,
                          fit: BoxFit.cover,
                          placeholder: (c, u) =>
                              Container(color: const Color(0xFFF6F6F6)),
                          errorWidget: (c, u, e) => Container(
                              color: const Color(0xFFF6F6F6),
                              child: const Icon(Icons.broken_image)),
                        ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(book.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            fontWeight: FontWeight.w700, fontSize: 16)),
                    const SizedBox(height: 6),
                    Text(
                        book.authors.isNotEmpty
                            ? book.authors.join(', ')
                            : 'Autor desconocido',
                        style: const TextStyle(color: Colors.black54)),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        ElevatedButton.icon(
                          onPressed: () async {
                            // navegar al detalle
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) =>
                                        BookDetailScreen(book: book)));
                          },
                          icon: const Icon(Icons.open_in_new, size: 18),
                          label: const Text('Ver'),
                          style: ElevatedButton.styleFrom(
                              minimumSize: const Size(80, 36)),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton.icon(
                          onPressed: () async {
                            final user =
                                ref.read(authStateProvider).asData?.value;
                            if (user == null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text('Inicia sesión primero')));
                              return;
                            }
                            try {
                              await ref
                                  .read(favoritesActionsProvider)
                                  .removeFavorite(book.id);
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text('Eliminado de favoritos')));
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Error: $e')));
                            }
                          },
                          icon: const Icon(Icons.delete_outline, size: 18),
                          label: const Text('Eliminar'),
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.redAccent,
                              minimumSize: const Size(100, 36)),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favsAsync = ref.watch(userFavoritesProvider);

    return Scaffold(
      appBar: AppBar(
          title: const Text(
              'LibSeek - Favoritos')), // AppBar con nombre de la app arriba
      body: favsAsync.when(
        data: (list) {
          if (list.isEmpty)
            return const Center(child: Text('No tienes favoritos'));
          return ListView.builder(
            padding: const EdgeInsets.only(top: 12, bottom: 24),
            itemCount: list.length,
            itemBuilder: (context, i) => _favCard(context, ref, list[i]),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
    );
  }
}
