import 'package:mysql_client/mysql_client.dart';
import '../models/conductor.dart';

class ConductorService {
  final MySQLConnection connection;

  ConductorService(this.connection);

  Future<List<Conductor>> listar() async {
    final result = await connection.execute('SELECT * FROM conductor ORDER BY id DESC');
    return result.rows.map((row) => Conductor.fromJson(row.assoc())).toList();
  }

  Future<Conductor> obtener(int id) async {
    final result = await connection.execute(
      'SELECT * FROM conductor WHERE id = :id',
      {'id': id},
    );
    if (result.rows.isEmpty) throw Exception('Conductor no encontrado');
    return Conductor.fromJson(result.rows.first.assoc());
  }

  Future<Conductor> crear(Map<String, dynamic> data) async {
    final result = await connection.execute(
      '''INSERT INTO conductor (user_id, licencia, nombre, apellido, telefono, correo, ci, estado)
         VALUES (:user_id, :licencia, :nombre, :apellido, :telefono, :correo, :ci, :estado)''',
      {
        'user_id': data['user_id'],
        'licencia': data['licencia'],
        'nombre': data['nombre'],
        'apellido': data['apellido'],
        'telefono': data['telefono'],
        'correo': data['correo'],
        'ci': data['ci'],
        'estado': data['estado'] ?? 'activo',
      },
    );
    return obtener(result.lastInsertID.toInt());
  }

  Future<Conductor> actualizar(int id, Map<String, dynamic> data) async {
    await connection.execute(
      '''UPDATE conductor SET
         user_id = :user_id, licencia = :licencia, nombre = :nombre,
         apellido = :apellido, telefono = :telefono, correo = :correo,
         ci = :ci, estado = :estado
         WHERE id = :id''',
      {
        'id': id,
        'user_id': data['user_id'],
        'licencia': data['licencia'],
        'nombre': data['nombre'],
        'apellido': data['apellido'],
        'telefono': data['telefono'],
        'correo': data['correo'],
        'ci': data['ci'],
        'estado': data['estado'] ?? 'activo',
      },
    );
    return obtener(id);
  }

  Future<void> eliminar(int id) async {
    await connection.execute('DELETE FROM conductor WHERE id = :id', {'id': id});
  }
}
