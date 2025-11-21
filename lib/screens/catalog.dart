// Pantalla principal de catálogo: búsqueda (TextField), resultados (ListView) y sección "Recomendados" (fila horizontal).
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/books_provider.dart';
import '../providers/recommended_provider.dart';
import '../widgets/book_card.dart';
import 'book_detail_placeholder.dart';

class CatalogScreen extends ConsumerStatefulWidget {
  const CatalogScreen({super.key});
  @override
  ConsumerState<CatalogScreen> createState() => _CatalogScreenState();
}

class _CatalogScreenState extends ConsumerState<CatalogScreen> {
  final ctrl = TextEditingController();

  void _onSearch() {
    final q = ctrl.text.trim();
    if (q.isEmpty) return;
    ref.read(booksSearchProvider.notifier).search(q);
  }

  @override
  Widget build(BuildContext context) {
    final results = ref.watch(booksSearchProvider);
    final recommendedAsync = ref.watch(recommendedBooksProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Catálogo')),
      body: Column(
        children: [
          // Búsqueda
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: ctrl,
                    textInputAction: TextInputAction.search,
                    decoration: InputDecoration(
                      hintText: 'Buscar título o autor',
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.search),
                        onPressed: _onSearch,
                      ),
                    ),
                    onSubmitted: (value) {
                      ref
                          .read(booksSearchProvider.notifier)
                          .search(value.trim()); // búsqueda con Enter
                    },
                  ),
                ),
              ],
            ),
          ),
          // Resultados
          Expanded(
            child: results.when(
              data: (books) {
                if (books.isEmpty)
                  return const Center(child: Text('Sin resultados'));
                return ListView.builder(
                  itemCount: books.length,
                  itemBuilder: (context, i) => BookCard(book: books[i]),
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('Error: $e')),
            ),
          ),
          // Recomendados horizontales
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text('Recomendados',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.indigo)),
              ],
            ),
          ),
          SizedBox(
            height: 160,
            child: recommendedAsync.when(
              data: (books) {
                if (books.isEmpty)
                  return const Center(child: Text('No hay recomendaciones'));
                return ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  itemCount: books.length,
                  itemBuilder: (context, i) {
                    final b = books[i];
                    return SizedBox(
                      width: 140,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: BookCard(
                            book: b,
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) =>
                                          BookDetailScreen(book: b)));
                            }),
                      ),
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (_, __) =>
                  const Center(child: Text('Error en recomendaciones')),
            ),
          ),
        ],
      ),
    );
  }
}
