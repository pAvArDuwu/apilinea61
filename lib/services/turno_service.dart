import 'package:mysql_client/mysql_client.dart';
import '../models/turno.dart';

class TurnoService {
  final MySQLConnection connection;

  TurnoService(this.connection);

  Future<List<Turno>> listar() async {
    final result = await connection.execute('SELECT * FROM turno ORDER BY id DESC');
    return result.rows.map((row) => Turno.fromJson(row.assoc())).toList();
  }

  Future<Turno> obtener(int id) async {
    final result = await connection.execute(
      'SELECT * FROM turno WHERE id = :id',
      {'id': id},
    );
    if (result.rows.isEmpty) throw Exception('Turno no encontrado');
    return Turno.fromJson(result.rows.first.assoc());
  }

  Future<Turno> crear(Map<String, dynamic> data) async {
    final result = await connection.execute(
      '''INSERT INTO turno (nombre, hora_inicio, hora_fin, descripcion, estado)
         VALUES (:nombre, :hora_inicio, :hora_fin, :descripcion, :estado)''',
      {
        'nombre': data['nombre'],
        'hora_inicio': data['hora_inicio'],
        'hora_fin': data['hora_fin'],
        'descripcion': data['descripcion'],
        'estado': data['estado'] ?? 'activo',
      },
    );
    return obtener(result.lastInsertID.toInt());
  }

  Future<Turno> actualizar(int id, Map<String, dynamic> data) async {
    await connection.execute(
      '''UPDATE turno SET
         nombre = :nombre, hora_inicio = :hora_inicio, hora_fin = :hora_fin,
         descripcion = :descripcion, estado = :estado
         WHERE id = :id''',
      {
        'id': id,
        'nombre': data['nombre'],
        'hora_inicio': data['hora_inicio'],
        'hora_fin': data['hora_fin'],
        'descripcion': data['descripcion'],
        'estado': data['estado'] ?? 'activo',
      },
    );
    return obtener(id);
  }

  Future<void> eliminar(int id) async {
    await connection.execute('DELETE FROM turno WHERE id = :id', {'id': id});
  }
}
