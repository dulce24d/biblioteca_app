// lib/screens/catalog.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/books_provider.dart';
import '../widgets/book_card.dart';

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

    return Scaffold(
      appBar: AppBar(title: const Text('Catálogo')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                    child: TextField(
                        controller: ctrl,
                        decoration: const InputDecoration(
                            hintText: 'Buscar título o autor'))),
                IconButton(
                    icon: const Icon(Icons.search), onPressed: _onSearch),
              ],
            ),
          ),
          Expanded(
            child: results.when(
              data: (books) {
                if (books.isEmpty) {
                  return const Center(child: Text('Sin resultados'));
                }
                return ListView.builder(
                  itemCount: books.length,
                  itemBuilder: (context, i) => BookCard(book: books[i]),
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('Error: $e')),
            ),
          ),
        ],
      ),
    );
  }
}
