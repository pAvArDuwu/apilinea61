import 'user.dart';
import 'micro.dart';

/// Modelo Propietario - Propietario de micro
/// Equivalente al modelo Propietario de Laravel (app/Models/Propietario.php)
class Propietario {
  final int id;
  final int userId;
  final String? nombre;
  final String? apellido;
  final String? telefono;
  final String? correo;
  final String? ci;
  final String estado;
  final DateTime? fechaRegistro;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  // Relaciones (opcionales, se cargan según necesidad)
  User? user;
  List<Micro>? micros;

  Propietario({
    required this.id,
    required this.userId,
    this.nombre,
    this.apellido,
    this.telefono,
    this.correo,
    this.ci,
    this.estado = 'activo',
    this.fechaRegistro,
    this.createdAt,
    this.updatedAt,
    this.user,
    this.micros,
  });

  factory Propietario.fromJson(Map<String, dynamic> json) {
    return Propietario(
      id: int.tryParse(json['id'].toString()) ?? 0,
      userId: int.tryParse(json['user_id'].toString()) ?? 0,
      nombre: json['nombre'] as String?,
      apellido: json['apellido'] as String?,
      telefono: json['telefono'] as String?,
      correo: json['correo'] as String?,
      ci: json['ci'] as String?,
      estado: json['estado'] as String? ?? 'activo',
      fechaRegistro: json['fecha_registro'] != null
          ? DateTime.parse(json['fecha_registro'] as String)
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
      'user_id': userId,
      'nombre': nombre,
      'apellido': apellido,
      'telefono': telefono,
      'correo': correo,
      'ci': ci,
      'estado': estado,
      'fecha_registro': fechaRegistro?.toIso8601String(),
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  /// Verifica si el propietario está activo
  bool get estaActivo => estado == 'activo';
}
