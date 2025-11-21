// Modelo que representa un préstamo (loan).
// Incluye conversiones para Firestore (toJson) y desde documento (fromJson).

class Loan {
  final String id;
  final String bookId;
  final String bookTitle;
  final String userId;
  final DateTime dateStart;
  final DateTime? dateEnd;
  final bool returned;

  Loan({
    required this.id,
    required this.bookId,
    required this.bookTitle,
    required this.userId,
    required this.dateStart,
    this.dateEnd,
    this.returned = false,
  });

  // Construye Loan a partir del documento de Firestore.
  // Nota: asume que dateStart y dateEnd están guardados como ISO strings.
  factory Loan.fromJson(Map<String, dynamic> json, String docId) {
    return Loan(
      id: docId,
      bookId: json['bookId'] as String? ?? '',
      bookTitle: json['bookTitle'] as String? ?? '',
      userId: json['userId'] as String? ?? '',
      dateStart: DateTime.parse(json['dateStart'] as String),
      dateEnd: json['dateEnd'] != null
          ? DateTime.parse(json['dateEnd'] as String)
          : null,
      returned: json['returned'] as bool? ?? false,
    );
  }

  // Convierte a mapa para guardar en Firestore.
  Map<String, dynamic> toJson() => {
        'bookId': bookId,
        'bookTitle': bookTitle,
        'userId': userId,
        'dateStart': dateStart.toIso8601String(),
        'dateEnd': dateEnd?.toIso8601String(),
        'returned': returned,
      };
}
