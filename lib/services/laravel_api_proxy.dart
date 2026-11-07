import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:shelf/shelf.dart';

/// Adapta las rutas móviles de ApiDart a la API transaccional de Laravel.
/// Laravel conserva la autenticación, autorización y reglas de negocio.
class LaravelApiProxy {
  LaravelApiProxy({HttpClient? client, String? baseUrl})
    : _client = client ?? HttpClient(),
      _baseUrl =
          (baseUrl ??
                  Platform.environment['LARAVEL_API_URL'] ??
                  'http://127.0.0.1:8001/api')
              .replaceFirst(RegExp(r'/+$'), '');

  final HttpClient _client;
  final String _baseUrl;

  Future<Response> forward(
    Request request,
    String path, {
    bool requireAuth = true,
  }) async {
    final authorization = request.headers['authorization'];
    final hasBearer =
        authorization != null &&
        authorization.toLowerCase().startsWith('bearer ');

    if (requireAuth && !hasBearer) {
      return _jsonResponse(401, {'message': 'Se requiere un token Bearer.'});
    }

    final query = request.url.hasQuery ? '?${request.url.query}' : '';
    final uri = Uri.parse('$_baseUrl$path$query');

    try {
      final outgoing = await _client
          .openUrl(request.method, uri)
          .timeout(const Duration(seconds: 15));
      if (hasBearer) {
        outgoing.headers.set(HttpHeaders.authorizationHeader, authorization);
      }
      outgoing.headers.set(HttpHeaders.acceptHeader, 'application/json');

      final contentType = request.headers['content-type'];
      if (contentType != null) {
        outgoing.headers.set(HttpHeaders.contentTypeHeader, contentType);
      }

      final body = await request.read().fold<List<int>>(<int>[], (
        bytes,
        chunk,
      ) {
        bytes.addAll(chunk);
        return bytes;
      });
      if (body.isNotEmpty) outgoing.add(body);

      final response = await outgoing.close().timeout(
        const Duration(seconds: 15),
      );
      final responseBody = await response.fold<List<int>>(<int>[], (
        bytes,
        chunk,
      ) {
        bytes.addAll(chunk);
        return bytes;
      });
      final responseHeaders = <String, String>{
        if (response.headers.contentType != null)
          HttpHeaders.contentTypeHeader: response.headers.contentType
              .toString(),
      };

      if (response.statusCode == HttpStatus.noContent ||
          response.statusCode == HttpStatus.notModified) {
        return Response(response.statusCode, headers: responseHeaders);
      }

      return Response(
        response.statusCode,
        body: responseBody,
        headers: responseHeaders,
      );
    } on TimeoutException {
      return _jsonResponse(502, {'message': 'Laravel no respondió a tiempo.'});
    } on SocketException {
      return _jsonResponse(502, {
        'message': 'No se pudo conectar con Laravel.',
      });
    } catch (_) {
      return _jsonResponse(502, {
        'message': 'No se pudo procesar la solicitud.',
      });
    }
  }

  Response _jsonResponse(int status, Map<String, dynamic> body) {
    return Response(
      status,
      body: jsonEncode(body),
      headers: {'content-type': 'application/json; charset=utf-8'},
    );
  }
}
