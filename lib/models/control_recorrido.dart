import 'asignacion_turno.dart';
import 'ruta_parada.dart';
import 'seguimiento_gps.dart';

/// Modelo ControlRecorrido - Sesión de control del recorrido
/// Equivalente al modelo ControlRecorrido de Laravel (app/Models/ControlRecorrido.php)
class ControlRecorrido {
  final int id;
  final int asignacionTurnoId;
  final int? rutaParadaId;
  final DateTime fechaHora;
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
    required this.fechaHora,
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
      id: json['id'] as int,
      asignacionTurnoId: json['asignacion_turno_id'] as int,
      rutaParadaId: json['ruta_parada_id'] as int?,
      fechaHora: DateTime.parse(json['fecha_hora'] as String),
      estado: json['estado'] as String? ?? 'pendiente',
      distanciaMetros: (json['distancia_metros'] as num?)?.toDouble(),
      observacion: json['observacion'] as String?,
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
      'asignacion_turno_id': asignacionTurnoId,
      'ruta_parada_id': rutaParadaId,
      'fecha_hora': fechaHora.toIso8601String(),
      'estado': estado,
      'distancia_metros': distanciaMetros,
      'observacion': observacion,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
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
