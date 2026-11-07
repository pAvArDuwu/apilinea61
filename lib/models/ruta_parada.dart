import '../utils/db_value.dart';
import 'ruta.dart';
import 'parada.dart';

/// Modelo RutaParada - Pivote ruta-parada con orden y sentido
/// Equivalente al modelo RutaParada de Laravel (app/Models/RutaParada.php)
class RutaParada {
  final int id;
  final int rutaId;
  final int paradaId;
  final int orden;
  final String sentido; // Ida | Vuelta
  final String estado;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  // Relaciones (opcionales, se cargan según necesidad)
  Ruta? ruta;
  Parada? parada;

  RutaParada({
    required this.id,
    required this.rutaId,
    required this.paradaId,
    required this.orden,
    required this.sentido,
    this.estado = 'activo',
    this.createdAt,
    this.updatedAt,
    this.ruta,
    this.parada,
  });

  factory RutaParada.fromJson(Map<String, dynamic> json) {
    return RutaParada(
      id: parseInt(json['id']) ?? 0,
      rutaId: parseInt(json['ruta_id']) ?? 0,
      paradaId: parseInt(json['parada_id']) ?? 0,
      orden: parseInt(json['orden']) ?? 0,
      sentido: json['sentido']?.toString() ?? 'Ida',
      estado: json['estado']?.toString() ?? 'activo',
      createdAt: parseDateTime(json['created_at']),
      updatedAt: parseDateTime(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'ruta_id': rutaId,
      'parada_id': paradaId,
      'orden': orden,
      'sentido': sentido,
      'estado': estado,
      'created_at': createdAt == null ? null : toMysqlDateTime(createdAt!),
      'updated_at': updatedAt == null ? null : toMysqlDateTime(updatedAt!),
    };
  }

  /// Verifica si la relación está activa
  bool get estaActiva => estado == 'activo';

  /// Verifica si el sentido es Ida
  bool get esIda => sentido == 'Ida';

  /// Verifica si el sentido es Vuelta
  bool get esVuelta => sentido == 'Vuelta';
}
