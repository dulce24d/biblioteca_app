import 'package:flutter/material.dart';
import '../models/book.dart';
import '../screens/book_detail_placeholder.dart' show BookDetailPlaceholder;
import 'package:cached_network_image/cached_network_image.dart';

// small placeholder page for book detail (you can implement full detail)
class BookCard extends StatelessWidget {
  final Book book;
  const BookCard({required this.book, super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: book.thumbnail.isEmpty
          ? const Icon(Icons.book)
          : SizedBox(
              width: 50,
              child: CachedNetworkImage(
                  imageUrl: book.thumbnail, fit: BoxFit.cover)),
      title: Text(book.title),
      subtitle: Text(book.authors.join(', ')),
      onTap: () => Navigator.push(context,
          MaterialPageRoute(builder: (_) => BookDetailPlaceholder(book: book))),
    );
  }
}
