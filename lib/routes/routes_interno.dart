import 'dart:convert';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:mysql_client/mysql_client.dart';
import '../services/interno_service.dart';

Router internoRoutes(MySQLConnection connection) {
  final router = Router();
  final service = InternoService(connection);

  router.get('/', (Request request) async {
    final internos = await service.listar();
    return Response.ok(jsonEncode(internos.map((i) => i.toJson()).toList()));
  });

  router.get('/<id>', (Request request, String id) async {
    try {
      final interno = await service.obtener(int.parse(id));
      return Response.ok(jsonEncode(interno.toJson()));
    } catch (e) {
      return Response.notFound(jsonEncode({'error': 'Interno no encontrado'}));
    }
  });

  router.post('/', (Request request) async {
    final body = await request.readAsString();
    final data = jsonDecode(body) as Map<String, dynamic>;
    final interno = await service.crear(data);
    return Response(201, body: jsonEncode(interno.toJson()));
  });

  router.put('/<id>', (Request request, String id) async {
    final body = await request.readAsString();
    final data = jsonDecode(body) as Map<String, dynamic>;
    final interno = await service.actualizar(int.parse(id), data);
    return Response.ok(jsonEncode(interno.toJson()));
  });

  router.delete('/<id>', (Request request, String id) async {
    await service.eliminar(int.parse(id));
    return Response.ok(jsonEncode({'mensaje': 'Interno eliminado'}));
  });

  return router;
}
