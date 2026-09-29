import 'package:mysql_client/mysql_client.dart';
import '../models/ruta.dart';

class RutaService {
  final MySQLConnection connection;

  RutaService(this.connection);

  Future<List<Ruta>> listar() async {
    final result = await connection.execute('SELECT * FROM ruta ORDER BY id DESC');
    return result.rows.map((row) => Ruta.fromJson(row.assoc())).toList();
  }

  Future<Ruta> obtener(int id) async {
    final result = await connection.execute(
      'SELECT * FROM ruta WHERE id = :id',
      {'id': id},
    );
    if (result.rows.isEmpty) throw Exception('Ruta no encontrada');
    return Ruta.fromJson(result.rows.first.assoc());
  }

  Future<Ruta> crear(Map<String, dynamic> data) async {
    final result = await connection.execute(
      '''INSERT INTO ruta (nombre, descripcion, estado)
         VALUES (:nombre, :descripcion, :estado)''',
      {
        'nombre': data['nombre'],
        'descripcion': data['descripcion'],
        'estado': data['estado'] ?? 'activo',
      },
    );
    return obtener(result.lastInsertID.toInt());
  }

  Future<Ruta> actualizar(int id, Map<String, dynamic> data) async {
    await connection.execute(
      '''UPDATE ruta SET
         nombre = :nombre, descripcion = :descripcion, estado = :estado
         WHERE id = :id''',
      {
        'id': id,
        'nombre': data['nombre'],
        'descripcion': data['descripcion'],
        'estado': data['estado'] ?? 'activo',
      },
    );
    return obtener(id);
  }

  Future<void> eliminar(int id) async {
    await connection.execute('DELETE FROM ruta WHERE id = :id', {'id': id});
  }
}
