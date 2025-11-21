// Modelo que representa un libro. Contiene dos constructores factory:
//  - fromJson: para parsear items de la API de Google Books (structure volumeInfo)
//  - fromMap: para parsear documentos guardados en Firestore (mapa plano)

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

  /// Construye desde la respuesta de Google Books (volumes item)
  /// IMPORTANTE: la estructura de Google Books usa `volumeInfo` y `imageLinks`.
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

  /// Construye desde el mapa que nosotros guardamos en Firestore (toJson())
  /// Esto permite leer documentos que guardaste con toJson().
  factory Book.fromMap(Map<String, dynamic> map) {
    return Book(
      id: (map['id'] as String?) ?? '',
      title: (map['title'] as String?) ?? 'Sin título',
      authors: ((map['authors'] as List<dynamic>?) ?? [])
          .map((a) => a.toString())
          .toList(),
      description: (map['description'] as String?) ?? '',
      thumbnail: (map['thumbnail'] as String?) ?? '',
    );
  }

  // Convierte el modelo a un mapa plano. Útil para guardar en Firestore.
  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'authors': authors,
        'description': description,
        'thumbnail': thumbnail,
      };
}
