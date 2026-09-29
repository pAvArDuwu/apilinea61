import 'package:mysql_client/mysql_client.dart';
import '../models/parada.dart';

class ParadaService {
  final MySQLConnection connection;

  ParadaService(this.connection);

  Future<List<Parada>> listar() async {
    final result = await connection.execute('SELECT * FROM paradas ORDER BY id DESC');
    return result.rows.map((row) => Parada.fromJson(row.assoc())).toList();
  }

  Future<Parada> obtener(int id) async {
    final result = await connection.execute(
      'SELECT * FROM paradas WHERE id = :id',
      {'id': id},
    );
    if (result.rows.isEmpty) throw Exception('Parada no encontrada');
    return Parada.fromJson(result.rows.first.assoc());
  }

  Future<Parada> crear(Map<String, dynamic> data) async {
    final result = await connection.execute(
      '''INSERT INTO paradas (nombre, referencia, latitud, longitud, estado)
         VALUES (:nombre, :referencia, :latitud, :longitud, :estado)''',
      {
        'nombre': data['nombre'],
        'referencia': data['referencia'],
        'latitud': data['latitud'],
        'longitud': data['longitud'],
        'estado': data['estado'] ?? 'activo',
      },
    );
    return obtener(result.lastInsertID.toInt());
  }

  Future<Parada> actualizar(int id, Map<String, dynamic> data) async {
    await connection.execute(
      '''UPDATE paradas SET
         nombre = :nombre, referencia = :referencia, latitud = :latitud,
         longitud = :longitud, estado = :estado
         WHERE id = :id''',
      {
        'id': id,
        'nombre': data['nombre'],
        'referencia': data['referencia'],
        'latitud': data['latitud'],
        'longitud': data['longitud'],
        'estado': data['estado'] ?? 'activo',
      },
    );
    return obtener(id);
  }

  Future<void> eliminar(int id) async {
    await connection.execute('DELETE FROM paradas WHERE id = :id', {'id': id});
  }
}
