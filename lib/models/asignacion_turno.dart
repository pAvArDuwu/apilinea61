import '../utils/db_value.dart';
import 'turno.dart';
import 'ruta.dart';
import 'micro.dart';
import 'conductor.dart';
import 'control_recorrido.dart';

/// Modelo AsignacionTurno - Operación diaria (fecha+turno+ruta+micro+conductor)
/// Equivalente al modelo AsignacionTurno de Laravel (app/Models/AsignacionTurno.php)
class AsignacionTurno {
  final int id;
  final String fecha;
  final int turnoId;
  final int rutaId;
  final int microId;
  final int conductorId;
  final String? horaSalida;
  final String? horaLlegada;
  final String estado; // pendiente | en_curso | completado | retrasado | cancelado
  final String? observaciones;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  // Relaciones (opcionales, se cargan según necesidad)
  Turno? turno;
  Ruta? ruta;
  Micro? micro;
  Conductor? conductor;
  List<ControlRecorrido>? controlesRecorrido;
  ControlRecorrido? controlRecorrido;

  AsignacionTurno({
    required this.id,
    required this.fecha,
    required this.turnoId,
    required this.rutaId,
    required this.microId,
    required this.conductorId,
    this.horaSalida,
    this.horaLlegada,
    this.estado = 'pendiente',
    this.observaciones,
    this.createdAt,
    this.updatedAt,
    this.turno,
    this.ruta,
    this.micro,
    this.conductor,
    this.controlesRecorrido,
    this.controlRecorrido,
  });

  factory AsignacionTurno.fromJson(Map<String, dynamic> json) {
    final asignacion = AsignacionTurno(
      id: parseInt(json['id']) ?? 0,
      fecha: json['fecha']?.toString() ?? '',
      turnoId: parseInt(json['turno_id']) ?? 0,
      rutaId: parseInt(json['ruta_id']) ?? 0,
      microId: parseInt(json['micro_id']) ?? 0,
      conductorId: parseInt(json['conductor_id']) ?? 0,
      horaSalida: json['hora_salida']?.toString(),
      horaLlegada: json['hora_llegada']?.toString(),
      estado: json['estado']?.toString() ?? 'pendiente',
      observaciones: json['observaciones']?.toString(),
      createdAt: parseDateTime(json['created_at']),
      updatedAt: parseDateTime(json['updated_at']),
    );

    if (json['turno'] is Map) {
      asignacion.turno = Turno.fromJson(
        Map<String, dynamic>.from(json['turno'] as Map),
      );
    }
    if (json['ruta'] is Map) {
      asignacion.ruta = Ruta.fromJson(
        Map<String, dynamic>.from(json['ruta'] as Map),
      );
    }
    if (json['micro'] is Map) {
      asignacion.micro = Micro.fromJson(
        Map<String, dynamic>.from(json['micro'] as Map),
      );
    }
    if (json['conductor'] is Map) {
      asignacion.conductor = Conductor.fromJson(
        Map<String, dynamic>.from(json['conductor'] as Map),
      );
    }
    if (json['control_recorrido'] is Map) {
      asignacion.controlRecorrido = ControlRecorrido.fromJson(
        Map<String, dynamic>.from(json['control_recorrido'] as Map),
      );
    }
    if (json['controles_recorrido'] is List) {
      asignacion.controlesRecorrido = (json['controles_recorrido'] as List)
          .whereType<Map>()
          .map((e) => ControlRecorrido.fromJson(Map<String, dynamic>.from(e)))
          .toList();
    }

    return asignacion;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fecha': fecha,
      'turno_id': turnoId,
      'ruta_id': rutaId,
      'micro_id': microId,
      'conductor_id': conductorId,
      'hora_salida': horaSalida,
      'hora_llegada': horaLlegada,
      'estado': estado,
      'observaciones': observaciones,
      'created_at': createdAt == null ? null : toMysqlDateTime(createdAt!),
      'updated_at': updatedAt == null ? null : toMysqlDateTime(updatedAt!),
      if (turno != null) 'turno': turno!.toJson(),
      if (ruta != null) 'ruta': ruta!.toJson(),
      if (micro != null) 'micro': micro!.toJson(),
      if (conductor != null) 'conductor': conductor!.toJson(),
      if (controlRecorrido != null)
        'control_recorrido': controlRecorrido!.toJson(),
      if (controlesRecorrido != null)
        'controles_recorrido':
            controlesRecorrido!.map((e) => e.toJson()).toList(),
    };
  }

  /// Verifica si la asignación está activa (no cancelada ni completada)
  bool get estaActivo => !['cancelado', 'completado'].contains(estado);

  /// Verifica si la asignación está pendiente
  bool get estaPendiente => estado == 'pendiente';

  /// Verifica si la asignación está en curso
  bool get estaEnCurso => estado == 'en_curso';

  /// Verifica si la asignación está completada
  bool get estaCompletado => estado == 'completado';

  /// Verifica si la asignación está retrasada
  bool get estaRetrasado => estado == 'retrasado';

  /// Verifica si la asignación está cancelada
  bool get estaCancelado => estado == 'cancelado';
}
