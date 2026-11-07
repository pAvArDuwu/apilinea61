import 'package:shelf_router/shelf_router.dart';
import '../services/laravel_api_proxy.dart';

Router asignacionTurnoRoutes(LaravelApiProxy proxy) {
  final router = Router();

  router.get('/', (request) => proxy.forward(request, '/asignacion-turnos'));
  router.get(
    '/<id>',
    (request, id) => proxy.forward(request, '/asignacion-turnos/$id'),
  );
  router.post('/', (request) => proxy.forward(request, '/asignacion-turnos'));
  router.put(
    '/<id>',
    (request, id) => proxy.forward(request, '/asignacion-turnos/$id'),
  );
  router.delete(
    '/<id>',
    (request, id) => proxy.forward(request, '/asignacion-turnos/$id'),
  );

  return router;
}
