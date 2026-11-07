/// Utilidades para normalizar valores que llegan desde MySQL.
///
/// `mysql_client` devuelve DECIMAL/BIGINT como `String` y DATETIME como
/// `String`; los endpoints JSON pueden devolver `int`/`double`. Estas
/// funciones aceptan ambos formatos y evitan los casts estrictos que
/// provocaban errores 500 en la API Dart.
library;

int? parseInt(dynamic value) {
  if (value == null) return null;
  if (value is int) return value;
  if (value is num) return value.toInt();
  return int.tryParse(value.toString());
}

double? parseDouble(dynamic value) {
  if (value == null) return null;
  if (value is double) return value;
  if (value is num) return value.toDouble();
  return double.tryParse(value.toString());
}

DateTime? parseDateTime(dynamic value) {
  if (value == null) return null;
  if (value is DateTime) return value;
  final texto = value.toString().trim();
  if (texto.isEmpty) return null;

  // MySQL entrega "YYYY-MM-DD HH:MM:SS"; DateTime.parse acepta el espacio.
  final directo = DateTime.tryParse(texto);
  if (directo != null) return directo;

  // Algunos controladores entregan "YYYY-MM-DDTHH:MM:SSZ".
  final normalizado = texto.replaceFirst(' ', 'T');
  return DateTime.tryParse(normalizado);
}

/// Formato DATETIME que MySQL acepta en modo estricto (sin T ni Z).
String toMysqlDateTime(DateTime value) {
  final local = value.toLocal();
  String dos(int n) => n.toString().padLeft(2, '0');
  return '${local.year.toString().padLeft(4, '0')}-'
      '${dos(local.month)}-${dos(local.day)} '
      '${dos(local.hour)}:${dos(local.minute)}:${dos(local.second)}';
}

/// Formato DATE de MySQL.
String toMysqlDate(DateTime value) {
  final local = value.toLocal();
  String dos(int n) => n.toString().padLeft(2, '0');
  return '${local.year.toString().padLeft(4, '0')}-${dos(local.month)}-${dos(local.day)}';
}
