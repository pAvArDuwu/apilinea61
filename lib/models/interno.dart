import 'micro.dart';

/// Modelo Interno - Número interno del micro
/// Equivalente al modelo Interno de Laravel (app/Models/Interno.php)
class Interno {
  final int id;
  final String numeroInterno;
  final DateTime? fechaIngreso;
  final String? observaciones;
  final String estado;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  // Relaciones (opcionales, se cargan según necesidad)
  Micro? micro;

  Interno({
    required this.id,
    required this.numeroInterno,
    this.fechaIngreso,
    this.observaciones,
    this.estado = 'disponible',
    this.createdAt,
    this.updatedAt,
    this.micro,
  });

  factory Interno.fromJson(Map<String, dynamic> json) {
    return Interno(
      id: int.tryParse(json['id'].toString()) ?? 0,
      numeroInterno: json['numero_interno'].toString(),
      fechaIngreso: json['fecha_ingreso'] != null
          ? DateTime.parse(json['fecha_ingreso'] as String)
          : null,
      observaciones: json['observaciones'] as String?,
      estado: json['estado'] as String? ?? 'disponible',
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
      'numero_interno': numeroInterno,
      'fecha_ingreso': fechaIngreso?.toIso8601String(),
      'observaciones': observaciones,
      'estado': estado,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  /// Verifica si el interno está disponible
  bool get estaDisponible => estado == 'disponible';

  /// Verifica si el interno está asignado
  bool get estaAsignado => estado == 'asignado';

  /// Verifica si el interno está inactivo
  bool get estaInactivo => estado == 'inactivo';
}
