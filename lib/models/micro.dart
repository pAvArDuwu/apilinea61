import 'propietario.dart';
import 'interno.dart';

/// Modelo Micro - Vehículo/microbus
/// Equivalente al modelo Micro de Laravel (app/Models/Micro.php)
class Micro {
  final int id;
  final int propietarioId;
  final int? internoId;
  final String? placa;
  final String? chasis;
  final int? anioFabricacion;
  final String? modelo;
  final String? marca;
  final int? capacidadPasajeros;
  final String estado;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  // Relaciones (opcionales, se cargan según necesidad)
  Propietario? propietario;
  Interno? interno;

  Micro({
    required this.id,
    required this.propietarioId,
    this.internoId,
    this.placa,
    this.chasis,
    this.anioFabricacion,
    this.modelo,
    this.marca,
    this.capacidadPasajeros,
    this.estado = 'activo',
    this.createdAt,
    this.updatedAt,
    this.propietario,
    this.interno,
  });

  factory Micro.fromJson(Map<String, dynamic> json) {
    return Micro(
      id: int.tryParse(json['id'].toString()) ?? 0,
      propietarioId: int.tryParse(json['propietario_id'].toString()) ?? 0,
      internoId: json['interno_id'] != null ? int.parse(json['interno_id'].toString()) : null,
      placa: json['placa'] as String?,
      chasis: json['chasis'] as String?,
      anioFabricacion: json['anio_fabricacion'] != null ? int.parse(json['anio_fabricacion'].toString()) : null,
      modelo: json['modelo'] as String?,
      marca: json['marca'] as String?,
      capacidadPasajeros: json['capacidad_pasajeros'] != null ? int.parse(json['capacidad_pasajeros'].toString()) : null,
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
      'propietario_id': propietarioId,
      'interno_id': internoId,
      'placa': placa,
      'chasis': chasis,
      'anio_fabricacion': anioFabricacion,
      'modelo': modelo,
      'marca': marca,
      'capacidad_pasajeros': capacidadPasajeros,
      'estado': estado,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  /// Verifica si el micro está activo
  bool get estaActivo => estado == 'activo';
}
