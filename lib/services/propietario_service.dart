import 'package:mysql_client/mysql_client.dart';
import '../models/propietario.dart';

class PropietarioService {
  final MySQLConnection connection;

  PropietarioService(this.connection);

  Future<List<Propietario>> listar() async {
    final result = await connection.execute('SELECT * FROM propietarios ORDER BY id DESC');
    return result.rows.map((row) => Propietario.fromJson(row.assoc())).toList();
  }

  Future<Propietario> obtener(int id) async {
    final result = await connection.execute(
      'SELECT * FROM propietarios WHERE id = :id',
      {'id': id},
    );
    if (result.rows.isEmpty) throw Exception('Propietario no encontrado');
    return Propietario.fromJson(result.rows.first.assoc());
  }

  Future<Propietario> crear(Map<String, dynamic> data) async {
    final result = await connection.execute(
      '''INSERT INTO propietarios (user_id, nombre, apellido, telefono, correo, ci, estado)
         VALUES (:user_id, :nombre, :apellido, :telefono, :correo, :ci, :estado)''',
      {
        'user_id': data['user_id'],
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

  Future<Propietario> actualizar(int id, Map<String, dynamic> data) async {
    await connection.execute(
      '''UPDATE propietarios SET
         user_id = :user_id, nombre = :nombre, apellido = :apellido,
         telefono = :telefono, correo = :correo, ci = :ci, estado = :estado
         WHERE id = :id''',
      {
        'id': id,
        'user_id': data['user_id'],
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
    await connection.execute('DELETE FROM propietarios WHERE id = :id', {'id': id});
  }
}
