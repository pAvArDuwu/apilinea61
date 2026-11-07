import 'package:shelf_router/shelf_router.dart';
import '../services/laravel_api_proxy.dart';

/// Endpoints móviles de asignación, recorrido y GPS.
/// El token Sanctum y el cuerpo llegan a Laravel sin alteraciones.
Router conductorEndpointsRoutes(LaravelApiProxy proxy) {
  final router = Router();

  // Autenticación y verificación: Laravel es la única fuente de usuarios.
  router.post(
    '/login',
    (request) => proxy.forward(request, '/login', requireAuth: false),
  );
  router.get('/me', (request) => proxy.forward(request, '/me'));
  router.post('/logout', (request) => proxy.forward(request, '/logout'));
  router.get(
    '/email/estado',
    (request) => proxy.forward(request, '/email/estado'),
  );
  router.post(
    '/email/reenviar',
    (request) => proxy.forward(request, '/email/reenviar'),
  );

  router.get(
    '/mis/asignaciones',
    (request) => proxy.forward(request, '/mis/asignaciones'),
  );
  router.get(
    '/mis/asignacion-actual',
    (request) => proxy.forward(request, '/mis/asignacion-actual'),
  );
  router.post(
    '/mis/asignaciones/<id>/iniciar',
    (request, id) => proxy.forward(request, '/mis/asignaciones/$id/iniciar'),
  );
  router.post(
    '/mis/asignaciones/<id>/finalizar',
    (request, id) => proxy.forward(request, '/mis/asignaciones/$id/finalizar'),
  );
  router.post(
    '/mis/asignaciones/<id>/ubicaciones',
    (request, id) =>
        proxy.forward(request, '/mis/asignaciones/$id/ubicaciones'),
  );
  router.post(
    '/mis/ubicaciones/sincronizar',
    (request) => proxy.forward(request, '/mis/ubicaciones/sincronizar'),
  );
  router.get(
    '/mis/asignaciones/<id>/recorrido',
    (request, id) => proxy.forward(request, '/mis/asignaciones/$id/recorrido'),
  );

  return router;
}
