// Utilidades generales usadas en la app (formateo de fechas, helpers UI).

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// Formatea una DateTime a 'dd/MM/yyyy'.
// Usado por varias pantallas para mostrar fechas legibles.
String formatDate(DateTime d) => DateFormat('dd/MM/yyyy').format(d);

// Muestra un SnackBar de error con fondo rojo.
// Helper centralizado para evitar repetir lógica de snackbars en pantallas.
void showErrorSnackBar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(message), backgroundColor: Colors.red),
  );
}
