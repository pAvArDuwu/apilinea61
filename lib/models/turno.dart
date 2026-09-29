import 'asignacion_turno.dart';

/// Modelo Turno - Catálogo de horarios (mañana/tarde/noche)
/// Equivalente al modelo Turno de Laravel (app/Models/Turno.php)
class Turno {
  final int id;
  final String nombre; // mañana | tarde | noche
  final String horaInicio;
  final String horaFin;
  final String? descripcion;
  final String estado;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  // Relaciones (opcionales, se cargan según necesidad)
  List<AsignacionTurno>? asignaciones;

  Turno({
    required this.id,
    required this.nombre,
    required this.horaInicio,
    required this.horaFin,
    this.descripcion,
    this.estado = 'activo',
    this.createdAt,
    this.updatedAt,
    this.asignaciones,
  });

  factory Turno.fromJson(Map<String, dynamic> json) {
    return Turno(
      id: int.tryParse(json['id'].toString()) ?? 0,
      nombre: json['nombre'].toString(),
      horaInicio: json['hora_inicio'].toString(),
      horaFin: json['hora_fin'].toString(),
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
      'hora_inicio': horaInicio,
      'hora_fin': horaFin,
      'descripcion': descripcion,
      'estado': estado,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  /// Etiquetas legibles para el enum nombre
  static const Map<String, String> nombres = {
    'mañana': 'Mañana',
    'tarde': 'Tarde',
    'noche': 'Noche',
  };

  /// Devuelve la etiqueta capitalizada del turno
  String get nombreLabel => nombres[nombre] ?? nombre;

  /// Verifica si el turno está activo
  bool get estaActivo => estado == 'activo';
}
