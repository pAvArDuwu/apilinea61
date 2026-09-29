import 'dart:convert';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:mysql_client/mysql_client.dart';
import '../services/propietario_service.dart';

Router propietarioRoutes(MySQLConnection connection) {
  final router = Router();
  final service = PropietarioService(connection);

  router.get('/', (Request request) async {
    final propietarios = await service.listar();
    return Response.ok(jsonEncode(propietarios.map((p) => p.toJson()).toList()));
  });

  router.get('/<id>', (Request request, String id) async {
    try {
      final propietario = await service.obtener(int.parse(id));
      return Response.ok(jsonEncode(propietario.toJson()));
    } catch (e) {
      return Response.notFound(jsonEncode({'error': 'Propietario no encontrado'}));
    }
  });

  router.post('/', (Request request) async {
    final body = await request.readAsString();
    final data = jsonDecode(body) as Map<String, dynamic>;
    final propietario = await service.crear(data);
    return Response(201, body: jsonEncode(propietario.toJson()));
  });

  router.put('/<id>', (Request request, String id) async {
    final body = await request.readAsString();
    final data = jsonDecode(body) as Map<String, dynamic>;
    final propietario = await service.actualizar(int.parse(id), data);
    return Response.ok(jsonEncode(propietario.toJson()));
  });

  router.delete('/<id>', (Request request, String id) async {
    await service.eliminar(int.parse(id));
    return Response.ok(jsonEncode({'mensaje': 'Propietario eliminado'}));
  });

  return router;
}
