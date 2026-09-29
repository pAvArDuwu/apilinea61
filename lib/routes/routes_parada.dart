import 'dart:convert';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:mysql_client/mysql_client.dart';
import '../services/parada_service.dart';

Router paradaRoutes(MySQLConnection connection) {
  final router = Router();
  final service = ParadaService(connection);

  router.get('/', (Request request) async {
    final paradas = await service.listar();
    return Response.ok(jsonEncode(paradas.map((p) => p.toJson()).toList()));
  });

  router.get('/<id>', (Request request, String id) async {
    try {
      final parada = await service.obtener(int.parse(id));
      return Response.ok(jsonEncode(parada.toJson()));
    } catch (e) {
      return Response.notFound(jsonEncode({'error': 'Parada no encontrada'}));
    }
  });

  router.post('/', (Request request) async {
    final body = await request.readAsString();
    final data = jsonDecode(body) as Map<String, dynamic>;
    final parada = await service.crear(data);
    return Response(201, body: jsonEncode(parada.toJson()));
  });

  router.put('/<id>', (Request request, String id) async {
    final body = await request.readAsString();
    final data = jsonDecode(body) as Map<String, dynamic>;
    final parada = await service.actualizar(int.parse(id), data);
    return Response.ok(jsonEncode(parada.toJson()));
  });

  router.delete('/<id>', (Request request, String id) async {
    await service.eliminar(int.parse(id));
    return Response.ok(jsonEncode({'mensaje': 'Parada eliminada'}));
  });

  return router;
}
