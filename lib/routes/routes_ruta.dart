import 'dart:convert';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:mysql_client/mysql_client.dart';
import '../services/ruta_service.dart';

Router rutaRoutes(MySQLConnection connection) {
  final router = Router();
  final service = RutaService(connection);

  router.get('/', (Request request) async {
    final rutas = await service.listar();
    return Response.ok(jsonEncode(rutas.map((r) => r.toJson()).toList()));
  });

  router.get('/<id>', (Request request, String id) async {
    try {
      final ruta = await service.obtener(int.parse(id));
      return Response.ok(jsonEncode(ruta.toJson()));
    } catch (e) {
      return Response.notFound(jsonEncode({'error': 'Ruta no encontrada'}));
    }
  });

  router.post('/', (Request request) async {
    final body = await request.readAsString();
    final data = jsonDecode(body) as Map<String, dynamic>;
    final ruta = await service.crear(data);
    return Response(201, body: jsonEncode(ruta.toJson()));
  });

  router.put('/<id>', (Request request, String id) async {
    final body = await request.readAsString();
    final data = jsonDecode(body) as Map<String, dynamic>;
    final ruta = await service.actualizar(int.parse(id), data);
    return Response.ok(jsonEncode(ruta.toJson()));
  });

  router.delete('/<id>', (Request request, String id) async {
    await service.eliminar(int.parse(id));
    return Response.ok(jsonEncode({'mensaje': 'Ruta eliminada'}));
  });

  return router;
}
