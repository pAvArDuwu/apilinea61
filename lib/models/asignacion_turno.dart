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
    return AsignacionTurno(
      id: int.tryParse(json['id'].toString()) ?? 0,
      fecha: json['fecha'].toString(),
      turnoId: int.tryParse(json['turno_id'].toString()) ?? 0,
      rutaId: int.tryParse(json['ruta_id'].toString()) ?? 0,
      microId: int.tryParse(json['micro_id'].toString()) ?? 0,
      conductorId: int.tryParse(json['conductor_id'].toString()) ?? 0,
      horaSalida: json['hora_salida'] as String?,
      horaLlegada: json['hora_llegada'] as String?,
      estado: json['estado'] as String? ?? 'pendiente',
      observaciones: json['observaciones'] as String?,
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
      'fecha': fecha,
      'turno_id': turnoId,
      'ruta_id': rutaId,
      'micro_id': microId,
      'conductor_id': conductorId,
      'hora_salida': horaSalida,
      'hora_llegada': horaLlegada,
      'estado': estado,
      'observaciones': observaciones,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
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
