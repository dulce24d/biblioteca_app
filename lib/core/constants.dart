// lib/core/constants.dart
// Constantes globales de la aplicación LibSeek

// -----------------------------------------------------------------------------
// URL del proxy (Cloud Function)
// Esta función reenvía imágenes y añade el header Access-Control-Allow-Origin.
const String? corsProxy =
    'https://us-central1-bibliotecaapp-a2d41.cloudfunctions.net/proxyImage';

// Base de la API de Google Books (usada por BooksService para búsquedas).
const String googleBooksApiBase = 'https://www.googleapis.com/books/v1';

// Máximo de resultados por petición (puedes ajustar)
const int googleBooksMaxResults = 20;

// Nombres de colecciones Firestore
const String usersCollection = 'users';
const String loansCollection = 'loans';
const String favoritesCollection = 'favorites';

const bool useCorsProxy = true;
