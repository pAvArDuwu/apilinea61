import 'dart:convert';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:mysql_client/mysql_client.dart';
import '../services/turno_service.dart';

Router turnoRoutes(MySQLConnection connection) {
  final router = Router();
  final service = TurnoService(connection);

  router.get('/', (Request request) async {
    final turnos = await service.listar();
    return Response.ok(jsonEncode(turnos.map((t) => t.toJson()).toList()));
  });

  router.get('/<id>', (Request request, String id) async {
    try {
      final turno = await service.obtener(int.parse(id));
      return Response.ok(jsonEncode(turno.toJson()));
    } catch (e) {
      return Response.notFound(jsonEncode({'error': 'Turno no encontrado'}));
    }
  });

  router.post('/', (Request request) async {
    final body = await request.readAsString();
    final data = jsonDecode(body) as Map<String, dynamic>;
    final turno = await service.crear(data);
    return Response(201, body: jsonEncode(turno.toJson()));
  });

  router.put('/<id>', (Request request, String id) async {
    final body = await request.readAsString();
    final data = jsonDecode(body) as Map<String, dynamic>;
    final turno = await service.actualizar(int.parse(id), data);
    return Response.ok(jsonEncode(turno.toJson()));
  });

  router.delete('/<id>', (Request request, String id) async {
    await service.eliminar(int.parse(id));
    return Response.ok(jsonEncode({'mensaje': 'Turno eliminado'}));
  });

  return router;
}
