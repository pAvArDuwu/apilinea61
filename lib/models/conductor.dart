import 'user.dart';

/// Modelo Conductor - Conductor de micro (perfil operativo)
/// Equivalente al modelo Conductor de Laravel (app/Models/Conductor.php)
class Conductor {
  final int id;
  final int userId;
  final String? licencia;
  final String? nombre;
  final String? apellido;
  final String? telefono;
  final String? correo;
  final String? ci;
  final String estado;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  // Relaciones (opcionales, se cargan según necesidad)
  User? user;

  Conductor({
    required this.id,
    required this.userId,
    this.licencia,
    this.nombre,
    this.apellido,
    this.telefono,
    this.correo,
    this.ci,
    this.estado = 'activo',
    this.createdAt,
    this.updatedAt,
    this.user,
  });

  factory Conductor.fromJson(Map<String, dynamic> json) {
    return Conductor(
      id: int.tryParse(json['id'].toString()) ?? 0,
      userId: int.tryParse(json['user_id'].toString()) ?? 0,
      licencia: json['licencia'] as String?,
      nombre: json['nombre'] as String?,
      apellido: json['apellido'] as String?,
      telefono: json['telefono'] as String?,
      correo: json['correo'] as String?,
      ci: json['ci'] as String?,
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
      'user_id': userId,
      'licencia': licencia,
      'nombre': nombre,
      'apellido': apellido,
      'telefono': telefono,
      'correo': correo,
      'ci': ci,
      'estado': estado,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  /// Nombre completo del conductor (accesor equivalente a getNombreCompletoAttribute)
  String get nombreCompleto {
    final n = (user?.name ?? nombre ?? '').trim();
    final a = (user?.apellido ?? apellido ?? '').trim();
    return '$n $a'.trim().isEmpty ? 'Sin conductor' : '$n $a'.trim();
  }

  /// Verifica si el conductor está activo
  bool get estaActivo => estado == 'activo';
}
