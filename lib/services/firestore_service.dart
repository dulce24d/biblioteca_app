// lib/services/firestore_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/loan.dart';
import '../models/book.dart';
import '../core/constants.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> saveLoan(Loan loan) async {
    final ref = _db
        .collection(usersCollection)
        .doc(loan.userId)
        .collection(loansCollection);
    await ref.add(loan.toJson());
  }

  Stream<List<Loan>> streamLoansForUser(String userId) {
    final ref =
        _db.collection(usersCollection).doc(userId).collection(loansCollection);
    return ref.orderBy('dateStart', descending: true).snapshots().map((snap) {
      return snap.docs
          .map((d) => Loan.fromJson(d.data() as Map<String, dynamic>, d.id))
          .toList();
    });
  }

  Future<void> markReturned(String userId, String loanId) async {
    final docRef = _db
        .collection(usersCollection)
        .doc(userId)
        .collection(loansCollection)
        .doc(loanId);
    await docRef.update({
      'returned': true,
      'dateEnd': DateTime.now().toIso8601String(),
    });
  }

  // -------- FAVORITES --------

  /// Adds or updates favorite for a user. Uses book.id as docId.
  Future<void> addFavorite(String userId, Book book) async {
    final ref =
        _db.collection(usersCollection).doc(userId).collection('favorites');
    await ref.doc(book.id).set(book.toJson());
  }

  /// Removes favorite
  Future<void> removeFavorite(String userId, String bookId) async {
    final ref =
        _db.collection(usersCollection).doc(userId).collection('favorites');
    await ref.doc(bookId).delete();
  }

  /// Stream favorites for user
  Stream<List<Book>> streamFavoritesForUser(String userId) {
    final ref =
        _db.collection(usersCollection).doc(userId).collection('favorites');
    return ref.snapshots().map((snap) {
      return snap.docs.map((d) {
        final map = d.data() as Map<String, dynamic>;
        return Book.fromMap(map); // <-- usar fromMap
      }).toList();
    });
  }

  /// Check if a book is favorite (one-time read)
  Future<bool> isFavorite(String userId, String bookId) async {
    final doc = await _db
        .collection(usersCollection)
        .doc(userId)
        .collection('favorites')
        .doc(bookId)
        .get();
    return doc.exists;
  }
}
