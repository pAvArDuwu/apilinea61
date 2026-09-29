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
      id: int.tryParse(json['id'].toString()) ?? 0,
      nombre: json['nombre'].toString(),
      referencia: json['referencia'] as String?,
      latitud: (json['latitud'] as num?)?.toDouble(),
      longitud: (json['longitud'] as num?)?.toDouble(),
      estado: json['estado'] as String? ?? 'activo',
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : null,
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
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  /// Verifica si la parada está activa
  bool get estaActiva => estado == 'activo';
}
