import 'package:flutter/material.dart';
import '../models/book.dart';

class BookDetailPlaceholder extends StatelessWidget {
  final Book book;
  const BookDetailPlaceholder({required this.book, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(book.title)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            if (book.thumbnail.isNotEmpty) Image.network(book.thumbnail),
            const SizedBox(height: 12),
            Text(book.title,
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text('Autores: ${book.authors.join(', ')}'),
            const SizedBox(height: 12),
            Text(book.description.isEmpty
                ? 'Sin descripción'
                : book.description),
          ],
        ),
      ),
    );
  }
}
