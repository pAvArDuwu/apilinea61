import 'dart:convert';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:mysql_client/mysql_client.dart';
import '../services/seguimiento_gps_service.dart';

Router seguimientoGpsRoutes(MySQLConnection connection) {
  final router = Router();
  final service = SeguimientoGpsService(connection);

  router.get('/', (Request request) async {
    final puntos = await service.listar();
    return Response.ok(jsonEncode(puntos.map((p) => p.toJson()).toList()));
  });

  router.get('/<id>', (Request request, String id) async {
    try {
      final punto = await service.obtener(int.parse(id));
      return Response.ok(jsonEncode(punto.toJson()));
    } catch (e) {
      return Response.notFound(jsonEncode({'error': 'Punto no encontrado'}));
    }
  });

  router.post('/', (Request request) async {
    final body = await request.readAsString();
    final data = jsonDecode(body) as Map<String, dynamic>;
    final punto = await service.crear(data);
    return Response(201, body: jsonEncode(punto.toJson()));
  });

  router.put('/<id>', (Request request, String id) async {
    final body = await request.readAsString();
    final data = jsonDecode(body) as Map<String, dynamic>;
    final punto = await service.actualizar(int.parse(id), data);
    return Response.ok(jsonEncode(punto.toJson()));
  });

  router.delete('/<id>', (Request request, String id) async {
    await service.eliminar(int.parse(id));
    return Response.ok(jsonEncode({'mensaje': 'Punto eliminado'}));
  });

  // Endpoint: Obtener puntos por control de recorrido
  router.get('/control/<controlId>', (Request request, String controlId) async {
    final puntos = await service.obtenerPorControl(int.parse(controlId));
    return Response.ok(jsonEncode(puntos.map((p) => p.toJson()).toList()));
  });

  // Endpoint: Sincronizar lote de puntos GPS
  router.post('/sincronizar', (Request request) async {
    final body = await request.readAsString();
    final data = jsonDecode(body) as Map<String, dynamic>;
    final puntos = data['puntos'] as List<dynamic>;
    final resultados = await service.sincronizarLote(
      puntos.map((p) => p as Map<String, dynamic>).toList(),
    );
    return Response.ok(jsonEncode({'resultados': resultados}));
  });

  return router;
}
