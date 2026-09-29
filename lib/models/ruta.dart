import 'parada.dart';
import 'ruta_parada.dart';
import 'asignacion_turno.dart';

/// Modelo Ruta - Ruta lógica
/// Equivalente al modelo Ruta de Laravel (app/Models/Ruta.php)
class Ruta {
  final int id;
  final String nombre;
  final String? descripcion;
  final String estado;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  // Relaciones (opcionales, se cargan según necesidad)
  List<Parada>? paradas;
  List<Parada>? paradasIda;
  List<Parada>? paradasVuelta;
  List<RutaParada>? rutaParadas;
  List<AsignacionTurno>? asignacionesTurno;

  Ruta({
    required this.id,
    required this.nombre,
    this.descripcion,
    this.estado = 'activo',
    this.createdAt,
    this.updatedAt,
    this.paradas,
    this.paradasIda,
    this.paradasVuelta,
    this.rutaParadas,
    this.asignacionesTurno,
  });

  factory Ruta.fromJson(Map<String, dynamic> json) {
    return Ruta(
      id: int.tryParse(json['id'].toString()) ?? 0,
      nombre: json['nombre'].toString(),
      descripcion: json['descripcion'] as String?,
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
      'descripcion': descripcion,
      'estado': estado,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  /// Verifica si la ruta está activa
  bool get estaActiva => estado == 'activo';
}
