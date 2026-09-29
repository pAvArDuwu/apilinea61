import 'dart:io';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:shelf_static/shelf_static.dart';
import 'package:untitled1/database/database.dart';
import 'package:untitled1/routes/routes_conductor.dart';
import 'package:untitled1/routes/routes_propietario.dart';
import 'package:untitled1/routes/routes_micro.dart';
import 'package:untitled1/routes/routes_interno.dart';
import 'package:untitled1/routes/routes_ruta.dart';
import 'package:untitled1/routes/routes_parada.dart';
import 'package:untitled1/routes/routes_turno.dart';
import 'package:untitled1/routes/routes_asignacion_turno.dart';
import 'package:untitled1/routes/routes_control_recorrido.dart';
import 'package:untitled1/routes/routes_seguimiento_gps.dart';
import 'package:untitled1/routes/routes_auth.dart';
import 'package:untitled1/routes/routes_conductor_endpoints.dart';

Future<void> main(List<String> args) async {
  final connection = await Database.connect();
  print('Conectado a MySQL.');

  final router = Router();

  // Health check
  router.get('/', (Request request) => Response.ok('API Línea 57 - Control de Turnos\n'));

  // Autenticación
  router.mount('/api', authRoutes(connection).call);
  
  // Endpoints específicos del conductor
  router.mount('/api', conductorEndpointsRoutes(connection).call);

  // Montar rutas del sistema de control de turnos
  router.mount('/api/conductores', conductorRoutes(connection).call);
  router.mount('/api/propietarios', propietarioRoutes(connection).call);
  router.mount('/api/micros', microRoutes(connection).call);
  router.mount('/api/internos', internoRoutes(connection).call);
  router.mount('/api/rutas', rutaRoutes(connection).call);
  router.mount('/api/paradas', paradaRoutes(connection).call);
  router.mount('/api/turnos', turnoRoutes(connection).call);
  router.mount('/api/asignaciones', asignacionTurnoRoutes(connection).call);
  router.mount('/api/controles', controlRecorridoRoutes(connection).call);
  router.mount('/api/gps', seguimientoGpsRoutes(connection).call);

  // Documentación estática
  final staticHandler = createStaticHandler(
    'public',
    defaultDocument: 'docs.html',
  );
  router.mount('/docs', staticHandler.call);

  final handler = Pipeline()
      .addMiddleware(logRequests())
      .addMiddleware(_corsMiddleware())
      .addHandler(router.call);

  final port = int.tryParse(Platform.environment['PORT'] ?? '') ?? 8000;
  await serve(handler, InternetAddress.anyIPv4, port);
  print('Servidor en http://localhost:$port');
  print('Documentación en http://localhost:$port/docs');
}

Middleware _corsMiddleware() {
  return (handler) {
    return (request) async {
      if (request.method == 'OPTIONS') {
        return Response.ok('', headers: _corsHeaders);
      }
      final response = await handler(request);
      return response.change(headers: {...response.headers, ..._corsHeaders});
    };
  };
}

const _corsHeaders = {
  'access-control-allow-origin': '*',
  'access-control-allow-methods': 'GET, POST, PUT, DELETE, OPTIONS',
  'access-control-allow-headers': 'Origin, Content-Type, Accept, Authorization',
};
