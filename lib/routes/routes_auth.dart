import 'dart:convert';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:mysql_client/mysql_client.dart';
import '../services/auth_service.dart';

Router authRoutes(MySQLConnection connection) {
  final router = Router();
  final service = AuthService(connection);

  // Login
  router.post('/login', (Request request) async {
    final body = await request.readAsString();
    final data = jsonDecode(body) as Map<String, dynamic>;
    
    final email = data['email'] as String?;
    final password = data['password'] as String?;
    
    if (email == null || password == null) {
      return Response(400, body: jsonEncode({'error': 'Email y contraseña son requeridos'}));
    }
    
    final result = await service.login(email, password);
    
    if (result == null) {
      return Response(401, body: jsonEncode({'error': 'Credenciales inválidas'}));
    }
    
    return Response.ok(jsonEncode(result));
  });

  // Logout
  router.post('/logout', (Request request) async {
    // En producción, invalidar el token
    return Response.ok(jsonEncode({'mensaje': 'Sesión cerrada'}));
  });

  // Me - Obtener usuario actual
  router.get('/me', (Request request) async {
    final authHeader = request.headers['Authorization'];
    if (authHeader == null || !authHeader.startsWith('Bearer ')) {
      return Response(401, body: jsonEncode({'error': 'No autorizado'}));
    }
    
    final token = authHeader.substring(7);
    final isValid = await service.verificarToken(token);
    
    if (!isValid) {
      return Response(401, body: jsonEncode({'error': 'Token inválido'}));
    }
    
    // Extraer user_id del token (simplificado)
    final parts = base64Decode(token).toString().split(':');
    final userId = int.tryParse(parts[0]);
    
    if (userId == null) {
      return Response(401, body: jsonEncode({'error': 'Token inválido'}));
    }
    
    final user = await service.obtenerUsuario(userId);
    
    if (user == null) {
      return Response(404, body: jsonEncode({'error': 'Usuario no encontrado'}));
    }
    
    return Response.ok(jsonEncode(user.toJson()));
  });

  return router;
}
