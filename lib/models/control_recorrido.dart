import '../utils/db_value.dart';
import 'asignacion_turno.dart';
import 'ruta_parada.dart';
import 'seguimiento_gps.dart';

/// Modelo ControlRecorrido - Sesión de control del recorrido
/// Equivalente al modelo ControlRecorrido de Laravel (app/Models/ControlRecorrido.php)
class ControlRecorrido {
  final int id;
  final int asignacionTurnoId;
  final int? rutaParadaId;
  final DateTime? fechaHora;
  final String estado; // pendiente | cumplido | omitido | fuera_ruta | en_curso | completado | cancelado
  final double? distanciaMetros;
  final String? observacion;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  // Relaciones (opcionales, se cargan según necesidad)
  AsignacionTurno? asignacionTurno;
  RutaParada? rutaParada;
  List<SeguimientoGps>? seguimientosGps;

  ControlRecorrido({
    required this.id,
    required this.asignacionTurnoId,
    this.rutaParadaId,
    this.fechaHora,
    this.estado = 'pendiente',
    this.distanciaMetros,
    this.observacion,
    this.createdAt,
    this.updatedAt,
    this.asignacionTurno,
    this.rutaParada,
    this.seguimientosGps,
  });

  factory ControlRecorrido.fromJson(Map<String, dynamic> json) {
    return ControlRecorrido(
      id: parseInt(json['id']) ?? 0,
      asignacionTurnoId: parseInt(json['asignacion_turno_id']) ?? 0,
      rutaParadaId: parseInt(json['ruta_parada_id']),
      fechaHora: parseDateTime(json['fecha_hora']),
      estado: json['estado']?.toString() ?? 'pendiente',
      distanciaMetros: parseDouble(json['distancia_metros']),
      observacion: json['observacion']?.toString(),
      createdAt: parseDateTime(json['created_at']),
      updatedAt: parseDateTime(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'asignacion_turno_id': asignacionTurnoId,
      'ruta_parada_id': rutaParadaId,
      'fecha_hora': fechaHora == null ? null : toMysqlDateTime(fechaHora!),
      'estado': estado,
      'distancia_metros': distanciaMetros,
      'observacion': observacion,
      'created_at': createdAt == null ? null : toMysqlDateTime(createdAt!),
      'updated_at': updatedAt == null ? null : toMysqlDateTime(updatedAt!),
    };
  }

  /// Verifica si el control está pendiente
  bool get estaPendiente => estado == 'pendiente';

  /// Verifica si el control está cumplido
  bool get estaCumplido => estado == 'cumplido';

  /// Verifica si el control está omitido
  bool get estaOmitido => estado == 'omitido';

  /// Verifica si el control está fuera de ruta
  bool get estaFueraRuta => estado == 'fuera_ruta';

  /// Verifica si el control está en curso
  bool get estaEnCurso => estado == 'en_curso';

  /// Verifica si el control está completado
  bool get estaCompletado => estado == 'completado';

  /// Verifica si el control está cancelado
  bool get estaCancelado => estado == 'cancelado';
}
