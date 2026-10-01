import 'dart:convert';
import 'package:mysql_client/mysql_client.dart';
import '../models/user.dart';

class AuthService {
  final MySQLConnection connection;

  AuthService(this.connection);

  /// Autenticar usuario con email y contraseña
  Future<Map<String, dynamic>?> login(String email, String password) async {
    final result = await connection.execute(
      'SELECT * FROM users WHERE email = :email',
      {'email': email},
    );
    
    if (result.rows.isEmpty) return null;
    
    final user = User.fromJson(result.rows.first.assoc());
    
    // Verificar contraseña (en producción usar bcrypt)
    if (user.password != password) return null;
    
    // Generar token simple (en producción usar JWT)
    final token = base64Encode(utf8.encode('${user.id}:${DateTime.now().millisecondsSinceEpoch}'));
    
    return {
      'token': token,
      'access_token': token,
      'token_type': 'Bearer',
      'user': user.toJson(),
    };
  }

  /// Obtener usuario por ID
  Future<User?> obtenerUsuario(int id) async {
    final result = await connection.execute(
      'SELECT * FROM users WHERE id = :id',
      {'id': id},
    );
    
    if (result.rows.isEmpty) return null;
    return User.fromJson(result.rows.first.assoc());
  }

  /// Verificar si el token es válido (simplificado)
  Future<bool> verificarToken(String token) async {
    // En producción, verificar JWT
    // Por ahora, verificamos que el token no esté vacío
    return token.isNotEmpty;
  }
}
