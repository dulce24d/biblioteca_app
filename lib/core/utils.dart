import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

String formatDate(DateTime d) => DateFormat('dd/MM/yyyy').format(d);

void showErrorSnackBar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(message), backgroundColor: Colors.red),
  );
}
