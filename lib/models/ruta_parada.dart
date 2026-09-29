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
      id: json['id'] as int,
      rutaId: json['ruta_id'] as int,
      paradaId: json['parada_id'] as int,
      orden: json['orden'] as int,
      sentido: json['sentido'] as String,
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
      'ruta_id': rutaId,
      'parada_id': paradaId,
      'orden': orden,
      'sentido': sentido,
      'estado': estado,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  /// Verifica si la relación está activa
  bool get estaActiva => estado == 'activo';

  /// Verifica si el sentido es Ida
  bool get esIda => sentido == 'Ida';

  /// Verifica si el sentido es Vuelta
  bool get esVuelta => sentido == 'Vuelta';
}
