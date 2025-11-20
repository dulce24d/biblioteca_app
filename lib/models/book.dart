class Book {
  final String id;
  final String title;
  final List<String> authors;
  final String description;
  final String thumbnail;

  Book({
    required this.id,
    required this.title,
    required this.authors,
    required this.description,
    required this.thumbnail,
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    final volumeInfo = json['volumeInfo'] as Map<String, dynamic>? ?? {};
    final imageLinks = volumeInfo['imageLinks'] as Map<String, dynamic>? ?? {};
    return Book(
      id: json['id']?.toString() ?? '',
      title: (volumeInfo['title'] as String?) ?? 'Sin título',
      authors: ((volumeInfo['authors'] as List<dynamic>?) ?? [])
          .map((a) => a.toString())
          .toList(),
      description: (volumeInfo['description'] as String?) ?? '',
      thumbnail: (imageLinks['thumbnail'] as String?) ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'authors': authors,
        'description': description,
        'thumbnail': thumbnail,
      };
}
