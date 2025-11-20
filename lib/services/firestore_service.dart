import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/loan.dart';
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
      return snap.docs.map((d) => Loan.fromJson(d.data(), d.id)).toList();
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
}
