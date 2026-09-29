import 'dart:convert';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:mysql_client/mysql_client.dart';
import '../services/conductor_service.dart';

Router conductorRoutes(MySQLConnection connection) {
  final router = Router();
  final service = ConductorService(connection);

  // Listar conductores
  router.get('/', (Request request) async {
    final conductores = await service.listar();
    return Response.ok(jsonEncode(conductores.map((c) => c.toJson()).toList()));
  });

  // Obtener conductor por ID
  router.get('/<id>', (Request request, String id) async {
    try {
      final conductor = await service.obtener(int.parse(id));
      return Response.ok(jsonEncode(conductor.toJson()));
    } catch (e) {
      return Response.notFound(jsonEncode({'error': 'Conductor no encontrado'}));
    }
  });

  // Crear conductor
  router.post('/', (Request request) async {
    final body = await request.readAsString();
    final data = jsonDecode(body) as Map<String, dynamic>;
    final conductor = await service.crear(data);
    return Response(201, body: jsonEncode(conductor.toJson()));
  });

  // Actualizar conductor
  router.put('/<id>', (Request request, String id) async {
    final body = await request.readAsString();
    final data = jsonDecode(body) as Map<String, dynamic>;
    final conductor = await service.actualizar(int.parse(id), data);
    return Response.ok(jsonEncode(conductor.toJson()));
  });

  // Eliminar conductor
  router.delete('/<id>', (Request request, String id) async {
    await service.eliminar(int.parse(id));
    return Response.ok(jsonEncode({'mensaje': 'Conductor eliminado'}));
  });

  return router;
}
