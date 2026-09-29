import 'package:mysql_client/mysql_client.dart';
import '../models/asignacion_turno.dart';

class AsignacionTurnoService {
  final MySQLConnection connection;

  AsignacionTurnoService(this.connection);

  Future<List<AsignacionTurno>> listar() async {
    final result = await connection.execute('SELECT * FROM asignacion_turnos ORDER BY id DESC');
    return result.rows.map((row) => AsignacionTurno.fromJson(row.assoc())).toList();
  }

  Future<AsignacionTurno> obtener(int id) async {
    final result = await connection.execute(
      'SELECT * FROM asignacion_turnos WHERE id = :id',
      {'id': id},
    );
    if (result.rows.isEmpty) throw Exception('Asignación no encontrada');
    return AsignacionTurno.fromJson(result.rows.first.assoc());
  }

  Future<AsignacionTurno> crear(Map<String, dynamic> data) async {
    final result = await connection.execute(
      '''INSERT INTO asignacion_turnos (fecha, turno_id, ruta_id, micro_id, conductor_id, hora_salida, hora_llegada, estado, observaciones)
         VALUES (:fecha, :turno_id, :ruta_id, :micro_id, :conductor_id, :hora_salida, :hora_llegada, :estado, :observaciones)''',
      {
        'fecha': data['fecha'],
        'turno_id': data['turno_id'],
        'ruta_id': data['ruta_id'],
        'micro_id': data['micro_id'],
        'conductor_id': data['conductor_id'],
        'hora_salida': data['hora_salida'],
        'hora_llegada': data['hora_llegada'],
        'estado': data['estado'] ?? 'pendiente',
        'observaciones': data['observaciones'],
      },
    );
    return obtener(result.lastInsertID.toInt());
  }

  Future<AsignacionTurno> actualizar(int id, Map<String, dynamic> data) async {
    await connection.execute(
      '''UPDATE asignacion_turnos SET
         fecha = :fecha, turno_id = :turno_id, ruta_id = :ruta_id,
         micro_id = :micro_id, conductor_id = :conductor_id, hora_salida = :hora_salida,
         hora_llegada = :hora_llegada, estado = :estado, observaciones = :observaciones
         WHERE id = :id''',
      {
        'id': id,
        'fecha': data['fecha'],
        'turno_id': data['turno_id'],
        'ruta_id': data['ruta_id'],
        'micro_id': data['micro_id'],
        'conductor_id': data['conductor_id'],
        'hora_salida': data['hora_salida'],
        'hora_llegada': data['hora_llegada'],
        'estado': data['estado'] ?? 'pendiente',
        'observaciones': data['observaciones'],
      },
    );
    return obtener(id);
  }

  Future<void> eliminar(int id) async {
    await connection.execute('DELETE FROM asignacion_turnos WHERE id = :id', {'id': id});
  }

  Future<AsignacionTurno?> obtenerAsignacionActual(int conductorId) async {
    final hoy = DateTime.now().toIso8601String().split('T')[0];
    final result = await connection.execute(
      '''SELECT * FROM asignacion_turnos 
         WHERE conductor_id = :conductor_id AND fecha = :fecha AND estado = 'en_curso'
         ORDER BY id DESC LIMIT 1''',
      {'conductor_id': conductorId, 'fecha': hoy},
    );
    if (result.rows.isEmpty) return null;
    return AsignacionTurno.fromJson(result.rows.first.assoc());
  }

  Future<List<AsignacionTurno>> obtenerAsignacionesPorConductor(int conductorId) async {
    final result = await connection.execute(
      'SELECT * FROM asignacion_turnos WHERE conductor_id = :conductor_id ORDER BY fecha DESC',
      {'conductor_id': conductorId},
    );
    return result.rows.map((row) => AsignacionTurno.fromJson(row.assoc())).toList();
  }

  Future<AsignacionTurno> iniciarTurno(int id) async {
    final ahora = DateTime.now();
    final horaSalida = '${ahora.hour.toString().padLeft(2, '0')}:${ahora.minute.toString().padLeft(2, '0')}:${ahora.second.toString().padLeft(2, '0')}';
    await connection.execute(
      "UPDATE asignacion_turnos SET estado = 'en_curso', hora_salida = :hora_salida WHERE id = :id",
      {'id': id, 'hora_salida': horaSalida},
    );
    return obtener(id);
  }

  Future<AsignacionTurno> finalizarTurno(int id) async {
    final ahora = DateTime.now();
    final horaLlegada = '${ahora.hour.toString().padLeft(2, '0')}:${ahora.minute.toString().padLeft(2, '0')}:${ahora.second.toString().padLeft(2, '0')}';
    await connection.execute(
      "UPDATE asignacion_turnos SET estado = 'completado', hora_llegada = :hora_llegada WHERE id = :id",
      {'id': id, 'hora_llegada': horaLlegada},
    );
    return obtener(id);
  }
}
