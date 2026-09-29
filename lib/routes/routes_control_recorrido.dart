import 'dart:convert';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:mysql_client/mysql_client.dart';
import '../services/control_recorrido_service.dart';

Router controlRecorridoRoutes(MySQLConnection connection) {
  final router = Router();
  final service = ControlRecorridoService(connection);

  router.get('/', (Request request) async {
    final controles = await service.listar();
    return Response.ok(jsonEncode(controles.map((c) => c.toJson()).toList()));
  });

  router.get('/<id>', (Request request, String id) async {
    try {
      final control = await service.obtener(int.parse(id));
      return Response.ok(jsonEncode(control.toJson()));
    } catch (e) {
      return Response.notFound(jsonEncode({'error': 'Control no encontrado'}));
    }
  });

  router.post('/', (Request request) async {
    final body = await request.readAsString();
    final data = jsonDecode(body) as Map<String, dynamic>;
    final control = await service.crear(data);
    return Response(201, body: jsonEncode(control.toJson()));
  });

  router.put('/<id>', (Request request, String id) async {
    final body = await request.readAsString();
    final data = jsonDecode(body) as Map<String, dynamic>;
    final control = await service.actualizar(int.parse(id), data);
    return Response.ok(jsonEncode(control.toJson()));
  });

  router.delete('/<id>', (Request request, String id) async {
    await service.eliminar(int.parse(id));
    return Response.ok(jsonEncode({'mensaje': 'Control eliminado'}));
  });

  // Endpoint: Obtener controles por asignación
  router.get('/asignacion/<asignacionId>', (Request request, String asignacionId) async {
    final controles = await service.obtenerPorAsignacion(int.parse(asignacionId));
    return Response.ok(jsonEncode(controles.map((c) => c.toJson()).toList()));
  });

  return router;
}
