import 'package:mysql_client/mysql_client.dart';
import '../models/micro.dart';

class MicroService {
  final MySQLConnection connection;

  MicroService(this.connection);

  Future<List<Micro>> listar() async {
    final result = await connection.execute('SELECT * FROM micro ORDER BY id DESC');
    return result.rows.map((row) => Micro.fromJson(row.assoc())).toList();
  }

  Future<Micro> obtener(int id) async {
    final result = await connection.execute(
      'SELECT * FROM micro WHERE id = :id',
      {'id': id},
    );
    if (result.rows.isEmpty) throw Exception('Micro no encontrado');
    return Micro.fromJson(result.rows.first.assoc());
  }

  Future<Micro> crear(Map<String, dynamic> data) async {
    final result = await connection.execute(
      '''INSERT INTO micro (propietario_id, interno_id, placa, chasis, anio_fabricacion, modelo, marca, capacidad_pasajeros, estado)
         VALUES (:propietario_id, :interno_id, :placa, :chasis, :anio_fabricacion, :modelo, :marca, :capacidad_pasajeros, :estado)''',
      {
        'propietario_id': data['propietario_id'],
        'interno_id': data['interno_id'],
        'placa': data['placa'],
        'chasis': data['chasis'],
        'anio_fabricacion': data['anio_fabricacion'],
        'modelo': data['modelo'],
        'marca': data['marca'],
        'capacidad_pasajeros': data['capacidad_pasajeros'],
        'estado': data['estado'] ?? 'activo',
      },
    );
    return obtener(result.lastInsertID.toInt());
  }

  Future<Micro> actualizar(int id, Map<String, dynamic> data) async {
    await connection.execute(
      '''UPDATE micro SET
         propietario_id = :propietario_id, interno_id = :interno_id, placa = :placa,
         chasis = :chasis, anio_fabricacion = :anio_fabricacion, modelo = :modelo,
         marca = :marca, capacidad_pasajeros = :capacidad_pasajeros, estado = :estado
         WHERE id = :id''',
      {
        'id': id,
        'propietario_id': data['propietario_id'],
        'interno_id': data['interno_id'],
        'placa': data['placa'],
        'chasis': data['chasis'],
        'anio_fabricacion': data['anio_fabricacion'],
        'modelo': data['modelo'],
        'marca': data['marca'],
        'capacidad_pasajeros': data['capacidad_pasajeros'],
        'estado': data['estado'] ?? 'activo',
      },
    );
    return obtener(id);
  }

  Future<void> eliminar(int id) async {
    await connection.execute('DELETE FROM micro WHERE id = :id', {'id': id});
  }
}
