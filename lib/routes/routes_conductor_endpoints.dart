import 'dart:convert';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:mysql_client/mysql_client.dart';
import '../services/asignacion_turno_service.dart';
import '../services/seguimiento_gps_service.dart';
import '../services/control_recorrido_service.dart';

/// Endpoints específicos del conductor para la app Flutter
Router conductorEndpointsRoutes(MySQLConnection connection) {
  final router = Router();
  final asignacionService = AsignacionTurnoService(connection);
  final gpsService = SeguimientoGpsService(connection);
  final controlService = ControlRecorridoService(connection);

  // Obtener asignaciones del conductor
  router.get('/mis/asignaciones', (Request request) async {
    final conductorId = int.tryParse(request.url.queryParameters['conductor_id'] ?? '');
    if (conductorId == null) {
      return Response(400, body: jsonEncode({'error': 'conductor_id es requerido'}));
    }
    
    final asignaciones = await asignacionService.obtenerAsignacionesPorConductor(conductorId);
    return Response.ok(jsonEncode(asignaciones.map((a) => a.toJson()).toList()));
  });

  // Obtener asignación actual del conductor
  router.get('/mis/asignacion-actual', (Request request) async {
    final conductorId = int.tryParse(request.url.queryParameters['conductor_id'] ?? '');
    if (conductorId == null) {
      return Response(400, body: jsonEncode({'error': 'conductor_id es requerido'}));
    }
    
    final asignacion = await asignacionService.obtenerAsignacionActual(conductorId);
    
    if (asignacion == null) {
      return Response.notFound(jsonEncode({'error': 'No hay asignación activa'}));
    }
    
    return Response.ok(jsonEncode(asignacion.toJson()));
  });

  // Iniciar turno
  router.post('/mis/asignaciones/<id>/iniciar', (Request request, String id) async {
    try {
      final asignacion = await asignacionService.iniciarTurno(int.parse(id));
      return Response.ok(jsonEncode(asignacion.toJson()));
    } catch (e) {
      return Response(400, body: jsonEncode({'error': e.toString()}));
    }
  });

  // Finalizar turno
  router.post('/mis/asignaciones/<id>/finalizar', (Request request, String id) async {
    try {
      final asignacion = await asignacionService.finalizarTurno(int.parse(id));
      return Response.ok(jsonEncode(asignacion.toJson()));
    } catch (e) {
      return Response(400, body: jsonEncode({'error': e.toString()}));
    }
  });

  // Enviar ubicación GPS
  router.post('/mis/asignaciones/<id>/ubicaciones', (Request request, String id) async {
    final body = await request.readAsString();
    final data = jsonDecode(body) as Map<String, dynamic>;
    
    final asignacionId = int.parse(id);
    final latitud = data['latitud'] as double?;
    final longitud = data['longitud'] as double?;
    final velocidad = data['velocidad'] as double?;
    
    if (latitud == null || longitud == null) {
      return Response(400, body: jsonEncode({'error': 'latitud y longitud son requeridos'}));
    }
    
    // Obtener o crear control de recorrido
    final controles = await controlService.obtenerPorAsignacion(asignacionId);
    int controlId;
    
    if (controles.isEmpty) {
      final nuevoControl = await controlService.crear({
        'asignacion_turno_id': asignacionId,
        'fecha_hora': DateTime.now().toIso8601String(),
        'estado': 'en_curso',
      });
      controlId = nuevoControl.id;
    } else {
      controlId = controles.first.id;
    }
    
    // Guardar punto GPS
    final punto = await gpsService.crear({
      'control_recorrido_id': controlId,
      'fecha_hora_gps': DateTime.now().toIso8601String(),
      'latitud': latitud,
      'longitud': longitud,
      'velocidad': velocidad,
      'fecha_hora_sincronizacion': DateTime.now().toIso8601String(),
    });
    
    return Response(201, body: jsonEncode(punto.toJson()));
  });

  // Sincronizar ubicaciones offline
  router.post('/mis/ubicaciones/sincronizar', (Request request) async {
    final body = await request.readAsString();
    final data = jsonDecode(body) as Map<String, dynamic>;
    final puntos = data['puntos'] as List<dynamic>;
    
    final resultados = <Map<String, dynamic>>[];
    
    for (final punto in puntos) {
      try {
        final p = punto as Map<String, dynamic>;
        final creado = await gpsService.crear(p);
        resultados.add({'exito': true, 'id': creado.id});
      } catch (e) {
        resultados.add({'exito': false, 'error': e.toString()});
      }
    }
    
    return Response.ok(jsonEncode({'resultados': resultados}));
  });

  // Obtener estado del recorrido
  router.get('/mis/asignaciones/<id>/recorrido', (Request request, String id) async {
    final asignacionId = int.parse(id);
    final controles = await controlService.obtenerPorAsignacion(asignacionId);
    
    if (controles.isEmpty) {
      return Response.ok(jsonEncode({'controles': [], 'gps': []}));
    }
    
    final control = controles.first;
    final puntosGps = await gpsService.obtenerPorControl(control.id);
    
    return Response.ok(jsonEncode({
      'control': control.toJson(),
      'gps': puntosGps.map((p) => p.toJson()).toList(),
    }));
  });

  return router;
}
