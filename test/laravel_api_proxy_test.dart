import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:shelf/shelf.dart';
import 'package:test/test.dart';
import 'package:untitled1/services/laravel_api_proxy.dart';

void main() {
  late HttpServer backend;
  late LaravelApiProxy proxy;

  setUp(() async {
    backend = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
    proxy = LaravelApiProxy(baseUrl: 'http://127.0.0.1:${backend.port}/api');
  });

  tearDown(() => backend.close(force: true));

  test('reenvía método, ruta, token, cuerpo y respuesta de Laravel', () async {
    final forwarded = Completer<Map<String, dynamic>>();
    backend.listen((request) async {
      final bytes = await request.fold<List<int>>(<int>[], (all, chunk) {
        all.addAll(chunk);
        return all;
      });
      forwarded.complete({
        'method': request.method,
        'path': request.uri.path,
        'query': request.uri.query,
        'authorization': request.headers.value('authorization'),
        'body': utf8.decode(bytes),
      });
      request.response.statusCode = HttpStatus.created;
      request.response.headers.contentType = ContentType.json;
      request.response.write('{"accepted":true}');
      await request.response.close();
    });

    final response = await proxy.forward(
      Request(
        'POST',
        Uri.parse('http://dart.test/api/ubicaciones?source=mobile'),
        headers: {
          'authorization': 'Bearer token-123',
          'content-type': 'application/json',
        },
        body: '{"latitud":-17.78}',
      ),
      '/mis/asignaciones/7/ubicaciones',
    );
    final request = await forwarded.future;

    expect(response.statusCode, HttpStatus.created);
    expect(await response.readAsString(), '{"accepted":true}');
    expect(request['method'], 'POST');
    expect(request['path'], '/api/mis/asignaciones/7/ubicaciones');
    expect(request['query'], 'source=mobile');
    expect(request['authorization'], 'Bearer token-123');
    expect(request['body'], '{"latitud":-17.78}');
  });

  test('rechaza solicitudes sin token Bearer', () async {
    final response = await proxy.forward(
      Request('GET', Uri.parse('http://dart.test/api/mis/asignaciones')),
      '/mis/asignaciones',
    );

    expect(response.statusCode, HttpStatus.unauthorized);
    expect(jsonDecode(await response.readAsString()), {
      'message': 'Se requiere un token Bearer.',
    });
  });

  test('reenvía el login sin token y sin cabecera Authorization', () async {
    final forwarded = Completer<Map<String, dynamic>>();
    backend.listen((request) async {
      forwarded.complete({
        'method': request.method,
        'path': request.uri.path,
        'authorization': request.headers.value('authorization'),
      });
      request.response.headers.contentType = ContentType.json;
      request.response.write('{"access_token":"nuevo"}');
      await request.response.close();
    });

    final response = await proxy.forward(
      Request(
        'POST',
        Uri.parse('http://dart.test/api/login'),
        body: '{"email":"a@b.c","password":"x"}',
        headers: {'content-type': 'application/json'},
      ),
      '/login',
      requireAuth: false,
    );
    final request = await forwarded.future;

    expect(response.statusCode, HttpStatus.ok);
    expect(await response.readAsString(), '{"access_token":"nuevo"}');
    expect(request['method'], 'POST');
    expect(request['path'], '/api/login');
    expect(request['authorization'], isNull);
  });
}
