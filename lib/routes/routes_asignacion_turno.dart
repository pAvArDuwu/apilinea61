import 'dart:convert';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:mysql_client/mysql_client.dart';
import '../services/asignacion_turno_service.dart';

Router asignacionTurnoRoutes(MySQLConnection connection) {
  final router = Router();
  final service = AsignacionTurnoService(connection);

  router.get('/', (Request request) async {
    final asignaciones = await service.listar();
    return Response.ok(jsonEncode(asignaciones.map((a) => a.toJson()).toList()));
  });

  router.get('/<id>', (Request request, String id) async {
    try {
      final asignacion = await service.obtener(int.parse(id));
      return Response.ok(jsonEncode(asignacion.toJson()));
    } catch (e) {
      return Response.notFound(jsonEncode({'error': 'Asignación no encontrada'}));
    }
  });

  router.post('/', (Request request) async {
    final body = await request.readAsString();
    final data = jsonDecode(body) as Map<String, dynamic>;
    final asignacion = await service.crear(data);
    return Response(201, body: jsonEncode(asignacion.toJson()));
  });

  router.put('/<id>', (Request request, String id) async {
    final body = await request.readAsString();
    final data = jsonDecode(body) as Map<String, dynamic>;
    final asignacion = await service.actualizar(int.parse(id), data);
    return Response.ok(jsonEncode(asignacion.toJson()));
  });

  router.delete('/<id>', (Request request, String id) async {
    await service.eliminar(int.parse(id));
    return Response.ok(jsonEncode({'mensaje': 'Asignación eliminada'}));
  });

  // Endpoint: Obtener asignación actual del conductor
  router.get('/conductor/<conductorId>/actual', (Request request, String conductorId) async {
    final asignacion = await service.obtenerAsignacionActual(int.parse(conductorId));
    if (asignacion == null) {
      return Response.notFound(jsonEncode({'error': 'No hay asignación activa'}));
    }
    return Response.ok(jsonEncode(asignacion.toJson()));
  });

  // Endpoint: Obtener asignaciones por conductor
  router.get('/conductor/<conductorId>', (Request request, String conductorId) async {
    final asignaciones = await service.obtenerAsignacionesPorConductor(int.parse(conductorId));
    return Response.ok(jsonEncode(asignaciones.map((a) => a.toJson()).toList()));
  });

  // Endpoint: Iniciar turno
  router.post('/<id>/iniciar', (Request request, String id) async {
    final asignacion = await service.iniciarTurno(int.parse(id));
    return Response.ok(jsonEncode(asignacion.toJson()));
  });

  // Endpoint: Finalizar turno
  router.post('/<id>/finalizar', (Request request, String id) async {
    final asignacion = await service.finalizarTurno(int.parse(id));
    return Response.ok(jsonEncode(asignacion.toJson()));
  });

  return router;
}
