// lib/models/loan.dart
// Modelo que representa un préstamo (loan) con portada para mostrar en historial.
// Ahora incluye campo `thumbnail` y lo guarda en Firestore.

class Loan {
  final String id;
  final String bookId;
  final String bookTitle;
  final String userId;
  final String? thumbnail;
  final DateTime dateStart;
  final DateTime? dateEnd;
  final bool returned;

  Loan({
    required this.id,
    required this.bookId,
    required this.bookTitle,
    required this.userId,
    this.thumbnail,
    required this.dateStart,
    this.dateEnd,
    this.returned = false,
  });

  // ---- Crear objeto desde Firestore ----
  factory Loan.fromJson(Map<String, dynamic> json, String docId) {
    return Loan(
      id: docId,
      bookId: json['bookId'] as String? ?? '',
      bookTitle: json['bookTitle'] as String? ?? '',
      userId: json['userId'] as String? ?? '',
      thumbnail: json['thumbnail'] as String?, // ✔ Nuevo
      dateStart: DateTime.parse(json['dateStart'] as String),
      dateEnd: json['dateEnd'] != null
          ? DateTime.parse(json['dateEnd'] as String)
          : null,
      returned: json['returned'] as bool? ?? false,
    );
  }

  // ---- Convertir a JSON para Firestore ----
  Map<String, dynamic> toJson() => {
        'bookId': bookId,
        'bookTitle': bookTitle,
        'userId': userId,
        'thumbnail': thumbnail, // ✔ Guardado también
        'dateStart': dateStart.toIso8601String(),
        'dateEnd': dateEnd?.toIso8601String(),
        'returned': returned,
      };
}
