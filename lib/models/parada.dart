import '../utils/db_value.dart';
import 'ruta.dart';

/// Modelo Parada - Parada geolocalizada
/// Equivalente al modelo Parada de Laravel (app/Models/Parada.php)
class Parada {
  final int id;
  final String nombre;
  final String? referencia;
  final double? latitud;
  final double? longitud;
  final String estado;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  // Relaciones (opcionales, se cargan según necesidad)
  List<Ruta>? rutas;

  Parada({
    required this.id,
    required this.nombre,
    this.referencia,
    this.latitud,
    this.longitud,
    this.estado = 'activo',
    this.createdAt,
    this.updatedAt,
    this.rutas,
  });

  factory Parada.fromJson(Map<String, dynamic> json) {
    return Parada(
      id: parseInt(json['id']) ?? 0,
      nombre: json['nombre']?.toString() ?? '',
      referencia: json['referencia']?.toString(),
      latitud: parseDouble(json['latitud']),
      longitud: parseDouble(json['longitud']),
      estado: json['estado']?.toString() ?? 'activo',
      createdAt: parseDateTime(json['created_at']),
      updatedAt: parseDateTime(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre': nombre,
      'referencia': referencia,
      'latitud': latitud,
      'longitud': longitud,
      'estado': estado,
      'created_at': createdAt == null ? null : toMysqlDateTime(createdAt!),
      'updated_at': updatedAt == null ? null : toMysqlDateTime(updatedAt!),
    };
  }

  /// Verifica si la parada está activa
  bool get estaActiva => estado == 'activo';
}
