import 'control_recorrido.dart';

/// Modelo SeguimientoGps - Posiciones GPS registradas
/// Equivalente al modelo SeguimientoGps de Laravel (app/Models/SeguimientoGps.php)
class SeguimientoGps {
  final int id;
  final int controlRecorridoId;
  final DateTime fechaHoraGps;
  final double latitud;
  final double longitud;
  final double? velocidad;
  final DateTime? fechaHoraSincronizacion;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  // Relaciones (opcionales, se cargan según necesidad)
  ControlRecorrido? controlRecorrido;

  SeguimientoGps({
    required this.id,
    required this.controlRecorridoId,
    required this.fechaHoraGps,
    required this.latitud,
    required this.longitud,
    this.velocidad,
    this.fechaHoraSincronizacion,
    this.createdAt,
    this.updatedAt,
    this.controlRecorrido,
  });

  factory SeguimientoGps.fromJson(Map<String, dynamic> json) {
    return SeguimientoGps(
      id: json['id'] as int,
      controlRecorridoId: json['control_recorrido_id'] as int,
      fechaHoraGps: DateTime.parse(json['fecha_hora_gps'] as String),
      latitud: (json['latitud'] as num).toDouble(),
      longitud: (json['longitud'] as num).toDouble(),
      velocidad: (json['velocidad'] as num?)?.toDouble(),
      fechaHoraSincronizacion: json['fecha_hora_sincronizacion'] != null
          ? DateTime.parse(json['fecha_hora_sincronizacion'] as String)
          : null,
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
      'control_recorrido_id': controlRecorridoId,
      'fecha_hora_gps': fechaHoraGps.toIso8601String(),
      'latitud': latitud,
      'longitud': longitud,
      'velocidad': velocidad,
      'fecha_hora_sincronizacion': fechaHoraSincronizacion?.toIso8601String(),
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
}
