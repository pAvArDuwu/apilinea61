import 'package:mysql_client/mysql_client.dart';
import '../models/control_recorrido.dart';

class ControlRecorridoService {
  final MySQLConnection connection;

  ControlRecorridoService(this.connection);

  Future<List<ControlRecorrido>> listar() async {
    final result = await connection.execute('SELECT * FROM control_recorrido ORDER BY id DESC');
    return result.rows.map((row) => ControlRecorrido.fromJson(row.assoc())).toList();
  }

  Future<ControlRecorrido> obtener(int id) async {
    final result = await connection.execute(
      'SELECT * FROM control_recorrido WHERE id = :id',
      {'id': id},
    );
    if (result.rows.isEmpty) throw Exception('Control no encontrado');
    return ControlRecorrido.fromJson(result.rows.first.assoc());
  }

  Future<ControlRecorrido> crear(Map<String, dynamic> data) async {
    final result = await connection.execute(
      '''INSERT INTO control_recorrido (asignacion_turno_id, ruta_parada_id, fecha_hora, estado, distancia_metros, observacion)
         VALUES (:asignacion_turno_id, :ruta_parada_id, :fecha_hora, :estado, :distancia_metros, :observacion)''',
      {
        'asignacion_turno_id': data['asignacion_turno_id'],
        'ruta_parada_id': data['ruta_parada_id'],
        'fecha_hora': data['fecha_hora'],
        'estado': data['estado'] ?? 'pendiente',
        'distancia_metros': data['distancia_metros'],
        'observacion': data['observacion'],
      },
    );
    return obtener(result.lastInsertID.toInt());
  }

  Future<ControlRecorrido> actualizar(int id, Map<String, dynamic> data) async {
    await connection.execute(
      '''UPDATE control_recorrido SET
         asignacion_turno_id = :asignacion_turno_id, ruta_parada_id = :ruta_parada_id,
         fecha_hora = :fecha_hora, estado = :estado, distancia_metros = :distancia_metros,
         observacion = :observacion
         WHERE id = :id''',
      {
        'id': id,
        'asignacion_turno_id': data['asignacion_turno_id'],
        'ruta_parada_id': data['ruta_parada_id'],
        'fecha_hora': data['fecha_hora'],
        'estado': data['estado'] ?? 'pendiente',
        'distancia_metros': data['distancia_metros'],
        'observacion': data['observacion'],
      },
    );
    return obtener(id);
  }

  Future<void> eliminar(int id) async {
    await connection.execute('DELETE FROM control_recorrido WHERE id = :id', {'id': id});
  }

  Future<List<ControlRecorrido>> obtenerPorAsignacion(int asignacionTurnoId) async {
    final result = await connection.execute(
      'SELECT * FROM control_recorrido WHERE asignacion_turno_id = :asignacion_turno_id ORDER BY fecha_hora DESC',
      {'asignacion_turno_id': asignacionTurnoId},
    );
    return result.rows.map((row) => ControlRecorrido.fromJson(row.assoc())).toList();
  }
}
