import '../utils/db_value.dart';
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
      id: parseInt(json['id']) ?? 0,
      controlRecorridoId: parseInt(json['control_recorrido_id']) ?? 0,
      fechaHoraGps: parseDateTime(json['fecha_hora_gps']) ?? DateTime.now(),
      latitud: parseDouble(json['latitud']) ?? 0,
      longitud: parseDouble(json['longitud']) ?? 0,
      velocidad: parseDouble(json['velocidad']),
      fechaHoraSincronizacion: parseDateTime(json['fecha_hora_sincronizacion']),
      createdAt: parseDateTime(json['created_at']),
      updatedAt: parseDateTime(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'control_recorrido_id': controlRecorridoId,
      'fecha_hora_gps': toMysqlDateTime(fechaHoraGps),
      'latitud': latitud,
      'longitud': longitud,
      'velocidad': velocidad,
      'fecha_hora_sincronizacion': fechaHoraSincronizacion == null
          ? null
          : toMysqlDateTime(fechaHoraSincronizacion!),
      'created_at': createdAt == null ? null : toMysqlDateTime(createdAt!),
      'updated_at': updatedAt == null ? null : toMysqlDateTime(updatedAt!),
    };
  }
}
