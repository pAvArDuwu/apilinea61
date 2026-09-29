import 'package:mysql_client/mysql_client.dart';
import '../models/interno.dart';

class InternoService {
  final MySQLConnection connection;

  InternoService(this.connection);

  Future<List<Interno>> listar() async {
    final result = await connection.execute('SELECT * FROM interno ORDER BY id DESC');
    return result.rows.map((row) => Interno.fromJson(row.assoc())).toList();
  }

  Future<Interno> obtener(int id) async {
    final result = await connection.execute(
      'SELECT * FROM interno WHERE id = :id',
      {'id': id},
    );
    if (result.rows.isEmpty) throw Exception('Interno no encontrado');
    return Interno.fromJson(result.rows.first.assoc());
  }

  Future<Interno> crear(Map<String, dynamic> data) async {
    final result = await connection.execute(
      '''INSERT INTO interno (numero_interno, fecha_ingreso, observaciones, estado)
         VALUES (:numero_interno, :fecha_ingreso, :observaciones, :estado)''',
      {
        'numero_interno': data['numero_interno'],
        'fecha_ingreso': data['fecha_ingreso'],
        'observaciones': data['observaciones'],
        'estado': data['estado'] ?? 'disponible',
      },
    );
    return obtener(result.lastInsertID.toInt());
  }

  Future<Interno> actualizar(int id, Map<String, dynamic> data) async {
    await connection.execute(
      '''UPDATE interno SET
         numero_interno = :numero_interno, fecha_ingreso = :fecha_ingreso,
         observaciones = :observaciones, estado = :estado
         WHERE id = :id''',
      {
        'id': id,
        'numero_interno': data['numero_interno'],
        'fecha_ingreso': data['fecha_ingreso'],
        'observaciones': data['observaciones'],
        'estado': data['estado'] ?? 'disponible',
      },
    );
    return obtener(id);
  }

  Future<void> eliminar(int id) async {
    await connection.execute('DELETE FROM interno WHERE id = :id', {'id': id});
  }
}
