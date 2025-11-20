import 'package:flutter/material.dart';
import '../models/loan.dart';
import '../core/utils.dart';

class LoanTile extends StatelessWidget {
  final Loan loan;
  final void Function(String loanId) onReturn;
  const LoanTile({required this.loan, required this.onReturn, super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(loan.bookTitle),
      subtitle: Text(
          'Prestado: ${formatDate(loan.dateStart)}${loan.returned ? ' • Devuelto' : ''}'),
      trailing: loan.returned
          ? const Icon(Icons.check, color: Colors.green)
          : ElevatedButton(
              onPressed: () => onReturn(loan.id),
              child: const Text('Marcar devuelto')),
    );
  }
}
