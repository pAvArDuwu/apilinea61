import 'package:mysql_client/mysql_client.dart';
import '../models/seguimiento_gps.dart';

class SeguimientoGpsService {
  final MySQLConnection connection;

  SeguimientoGpsService(this.connection);

  Future<List<SeguimientoGps>> listar() async {
    final result = await connection.execute('SELECT * FROM seguimiento_gps ORDER BY id DESC');
    return result.rows.map((row) => SeguimientoGps.fromJson(row.assoc())).toList();
  }

  Future<SeguimientoGps> obtener(int id) async {
    final result = await connection.execute(
      'SELECT * FROM seguimiento_gps WHERE id = :id',
      {'id': id},
    );
    if (result.rows.isEmpty) throw Exception('Punto no encontrado');
    return SeguimientoGps.fromJson(result.rows.first.assoc());
  }

  Future<SeguimientoGps> crear(Map<String, dynamic> data) async {
    final result = await connection.execute(
      '''INSERT INTO seguimiento_gps (control_recorrido_id, fecha_hora_gps, latitud, longitud, velocidad, fecha_hora_sincronizacion)
         VALUES (:control_recorrido_id, :fecha_hora_gps, :latitud, :longitud, :velocidad, :fecha_hora_sincronizacion)''',
      {
        'control_recorrido_id': data['control_recorrido_id'],
        'fecha_hora_gps': data['fecha_hora_gps'],
        'latitud': data['latitud'],
        'longitud': data['longitud'],
        'velocidad': data['velocidad'],
        'fecha_hora_sincronizacion': data['fecha_hora_sincronizacion'],
      },
    );
    return obtener(result.lastInsertID.toInt());
  }

  Future<SeguimientoGps> actualizar(int id, Map<String, dynamic> data) async {
    await connection.execute(
      '''UPDATE seguimiento_gps SET
         control_recorrido_id = :control_recorrido_id, fecha_hora_gps = :fecha_hora_gps,
         latitud = :latitud, longitud = :longitud, velocidad = :velocidad,
         fecha_hora_sincronizacion = :fecha_hora_sincronizacion
         WHERE id = :id''',
      {
        'id': id,
        'control_recorrido_id': data['control_recorrido_id'],
        'fecha_hora_gps': data['fecha_hora_gps'],
        'latitud': data['latitud'],
        'longitud': data['longitud'],
        'velocidad': data['velocidad'],
        'fecha_hora_sincronizacion': data['fecha_hora_sincronizacion'],
      },
    );
    return obtener(id);
  }

  Future<void> eliminar(int id) async {
    await connection.execute('DELETE FROM seguimiento_gps WHERE id = :id', {'id': id});
  }

  Future<List<SeguimientoGps>> obtenerPorControl(int controlRecorridoId) async {
    final result = await connection.execute(
      'SELECT * FROM seguimiento_gps WHERE control_recorrido_id = :control_recorrido_id ORDER BY fecha_hora_gps ASC',
      {'control_recorrido_id': controlRecorridoId},
    );
    return result.rows.map((row) => SeguimientoGps.fromJson(row.assoc())).toList();
  }

  Future<List<Map<String, dynamic>>> sincronizarLote(List<Map<String, dynamic>> puntos) async {
    final resultados = <Map<String, dynamic>>[];
    for (final punto in puntos) {
      try {
        final creado = await crear(punto);
        resultados.add({'exito': true, 'id': creado.id});
      } catch (e) {
        resultados.add({'exito': false, 'error': e.toString()});
      }
    }
    return resultados;
  }
}
