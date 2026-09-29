import 'dart:convert';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:mysql_client/mysql_client.dart';
import '../services/micro_service.dart';

Router microRoutes(MySQLConnection connection) {
  final router = Router();
  final service = MicroService(connection);

  router.get('/', (Request request) async {
    final micros = await service.listar();
    return Response.ok(jsonEncode(micros.map((m) => m.toJson()).toList()));
  });

  router.get('/<id>', (Request request, String id) async {
    try {
      final micro = await service.obtener(int.parse(id));
      return Response.ok(jsonEncode(micro.toJson()));
    } catch (e) {
      return Response.notFound(jsonEncode({'error': 'Micro no encontrado'}));
    }
  });

  router.post('/', (Request request) async {
    final body = await request.readAsString();
    final data = jsonDecode(body) as Map<String, dynamic>;
    final micro = await service.crear(data);
    return Response(201, body: jsonEncode(micro.toJson()));
  });

  router.put('/<id>', (Request request, String id) async {
    final body = await request.readAsString();
    final data = jsonDecode(body) as Map<String, dynamic>;
    final micro = await service.actualizar(int.parse(id), data);
    return Response.ok(jsonEncode(micro.toJson()));
  });

  router.delete('/<id>', (Request request, String id) async {
    await service.eliminar(int.parse(id));
    return Response.ok(jsonEncode({'mensaje': 'Micro eliminado'}));
  });

  return router;
}
